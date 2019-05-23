require "./DataSrv/Script/sysDef"

math.randomseed(os.time())

quest = FieldSet.get("Party1")
fieldID = self->field()->getID()
field = self->field()

desc_stage2 = "嗨，歡迎來到第二關卡。您會看到在我旁邊有數條繩子，請找出3個正確的繩子並且爬在上面，再讓隊長與我交談，如果全數正確，就能進入下一關卡。注意，爬得太低可能不會被計算。"
desc_stage3 = "嗨，歡迎來到第三關卡。您會看到在我旁邊有數個木桶，請找出3個正確的木桶並且站在上面，再讓隊長與我交談，如果全數正確，就能進入下一關卡。注意，站的太靠近邊緣可能不會被計算。"
desc_stage4 = "嗨，歡迎來到第四關卡。您會看到在我旁邊有數個木桶，請找出3個正確的木桶並且站在上面，再讓隊長與我交談，如果全數正確，就能進入下一關卡。注意，站的太靠近邊緣可能不會被計算。"
desc_stage5 = "哈囉，歡迎來到最後一關。請在地圖中找出超級綠水靈。擊敗地圖中的所有怪物，收集#b通行證#k並且交給我。當您獲得了#b通行證#k，請統一交給隊長，並由隊長交給我。請小心，四周的怪物看��來雖然很熟悉，但卻更加強大，請務必小心。祝您好運！\r\n當您完成了所有的任務，請找我領取獎勵。"

function makeAnswer(numCount, answerCount) 
    rndSeq = randomSeq(1, numCount)
    ret = ""
    for k, v in pairs(rndSeq) do
        if(v > answerCount) then
            ret = ret .. '0'
        else
            ret = ret .. '1'
        end
    end
    return ret
end

function areaCheck(areaCount, answerCount)
    ret = ""
    areaCount = areaCount - 1
    count = 0
    for i = 0, areaCount do
        inArea = field->countUserInArea(i)
        count = count + inArea
        ret = ret .. inArea
    end
    if(count ~= answerCount) then return 0 end
    return ret
end

function stageCleared()
    field->effectScreen( "quest/party/clear" )
    field->effectSound( "Party1/Clear" )
    field->effectObject( "gate" )
    field->enablePortal( "next00", 1)
end

function party1_personal()
    charKey = userID .. "_"
    prob = quest->getVar(charKey)
    if(prob == "clear") then self->say("請等待其他人完成。") return end
    q = prob
    if(q == "") then q = random(1, 7) end
    desc = ""
    ans = ""
    if(tonumber(q) == 1) then desc = "在楓之谷世界裡，#r劍士要一轉時，最低的等級數字是多少？#k。請把正確的票券找來。"; ans = 10
    elseif(tonumber(q) == 2) then desc = "在楓之谷世界裡，#r劍士要一轉時，最低的力量數字是多少？#k。請把正確的票券找來。"; ans = 35
    elseif(tonumber(q) == 3) then desc = "在楓之谷世界裡，#r法師要進行一轉時，最低的智力數字是多少？#k。請把正確的票券找來。"; ans = 25
    elseif(tonumber(q) == 4) then desc = "在楓之谷世界裡，#r弓箭手要一轉時，最低的敏捷數字是多少？#k。請把正確的票券找來。" ans = 25
    elseif(tonumber(q) == 5) then desc = "在楓之谷世界裡，#r要進行二轉時，最低的等級數字是多少？#k。請把正確的票券找來。" ans = 30
    elseif(tonumber(q) == 6) then desc = "在楓之谷世界裡，#r法師要進行一轉時，最低的等級數字是多少？#k。請把正確的票券找來。" ans = 8 
    end

    if(prob == "") then
        quest->setVar( charKey, q )
        self->say("歡迎來到第一關卡，接下來我會詢問每個組員一道問題，請每個人打倒鱷魚怪並收集票券，數量要和我所提出的問題的答案一樣多，然後把#b票券#k收集過來。準備好接受問題了嗎？")
        self->say(desc)
        return
    end

    if(inventory->itemCount(4001007) == ans) then
        if(inventory->exchange(0, 4001007, -ans, 4001008, 1) ~= 0) then
            self->say("請確認您的背包還有足夠的空間。")
            return
        end
        quest->setVar(charKey, "clear")
        self->say("數量正確！那我現在就把#b通行證#k給您！請交給隊伍中的隊長。")
    else
        self->say("很抱歉，這不是正確的答案！數量要和我所提出的問題的答案一樣多。請根據問題取得正確數量的票券。")
        self->say(desc) 
    end
end

function party1_stage1()
    stage = quest->getVar("stage")
    ansCount = quest->getUserCount() - 1

    if(stage == "") then
        self->say("嗨。歡迎來到第一關卡，看看這裡的四周，充滿著鱷魚怪，您們必須同心協力打敗這些鱷魚怪，這些鱷魚怪會掉落#b票券#k。除了隊長之外，每個組員�m應該與我談話，我會給他們一個簡單的問題，他們必須收集跟問題答案一樣數量的#b票券#k，接著我就會給他們#b通行證#k，當所有的組員�m收集到了#b通行證#k，全部交給隊長，並且由隊長再次與我談話，就可以完成這個關卡，時間有限，請把握時間，祝您們好運。")
        quest->setVar("stage", "1")
        return
    end

    if(stage ~= "1") then self->say("傳送門已經開啟，請加快腳步前往下一個關卡！") return end
    if(inventory->itemCount(4001008) < ansCount) then 
        self->say("很抱歉，您所收集的通行證數量不足。收集的通行證數量是扣除隊長後組員的數量，也就是 " .. ansCount .. " 張才可以完成關卡。請您的組員盡快得出問題的答案，收集與答案數量一樣多的#b票券#k，然後將#b通行證#k交給您。")
    else
        if(inventory->exchange(0, 4001008, -ansCount) ~= 0) then return end
        stageCleared()
        quest->incExpAll(100)
        quest->setVar( "stage", "2" )
    end
end

function party1_stage2()
    if(quest->getVar("stage") ~= "2") then return end
    question = quest->getVar("stage2_q")
    if(question == "") then
        self->say(desc_stage2)
        question = makeAnswer(4, quest->getUserCount())
        quest->setVar("stage2_q", question)
        return
    end
    answer = areaCheck(4, 3)
    if(answer == 0) then
        self->say("請確保足夠的玩家已經在繩子上。" .. makeAnswer(6, 3))
    elseif(question ~= answer) then
        field->effectScreen("quest/party/wrong_kor")
        field->effectSound("Party1/Failed")
    else
        stageCleared()
        quest->incExpAll(200)
        quest->setVar( "stage", "3" )
    end
end

function party1_stage3()
    if(quest->getVar("stage") ~= "3") then return end
    question = quest->getVar("stage3_q")
    if(question == "") then
        self->say(desc_stage3)
        question = makeAnswer(5, quest->getUserCount())
        quest->setVar("stage3_q", question)
        return
    end
    answer = areaCheck(5, 3)
    if(answer == 0) then
        self->say("請確保足夠的玩家已經在木桶上。")
    elseif(question ~= answer) then
        field->effectScreen("quest/party/wrong_kor")
        field->effectSound("Party1/Failed")
    else
        stageCleared()
        quest->incExpAll(400)
        quest->setVar( "stage", "4" )
    end
end

function party1_stage4()
    if(quest->getVar("stage") ~= "4") then return end
    question = quest->getVar("stage4_q")
    if(question == "") then
        self->say(desc_stage4)
        question = makeAnswer(6, quest->getUserCount())
        quest->setVar("stage4_q", question)
        return
    end
    answer = areaCheck(6, 2)
    if(answer == 0) then
        self->say("請確保足夠的玩家已經在繩子上。")
    elseif(question ~= answer) then
        field->effectScreen("quest/party/wrong_kor")
        field->effectSound("Party1/Failed")
    else
        stageCleared()
        quest->incExpAll(800)
        quest->setVar( "stage", "5" )
    end
end

function party1_stage5()
    if(quest->getVar("stage") ~= "5") then return end
    count = inventory->itemCount(4001008, 10)
    if(count ~= 10) then
        self->say(desc_stage5)
    else
        inventory->exchange(0, 4001008, -count)
        stageCleared()
        quest->incExpAll(1500)
        quest->setVar( "stage", "5" )
        self->say("這是可以通往最後的獎勵關卡的傳送門。裡面的怪物您一定能輕鬆打敗，請在時間限制內盡量的擊敗怪物，您也可以中途就離開。最後，還是恭喜您！再見了...")
    end
end

function party1_help()
    if ( fieldID == 103000801 ) then self->say(desc_stage2)
    elseif ( fieldID == 103000802 ) then self->say(desc_stage3)
    elseif ( fieldID == 103000803 ) then self->say(desc_stage4) 
    elseif ( fieldID == 103000804 ) then self->say(desc_stage5) 
    end
end

function party1_reward()
    rnum = random( 0, 39 ) 
    nNewItemID = 0 
    nNewItemNum = 0 
    if ( rnum == 0 )  then
        nNewItemID = 2000004 
        nNewItemNum = 5 
    elseif ( rnum == 1 )  then
        nNewItemID = 2000001 
        nNewItemNum = 100 
    elseif ( rnum == 2 )  then
        nNewItemID = 2000002 
        nNewItemNum = 70 
    elseif ( rnum == 3 )  then
        nNewItemID = 2000003 
        nNewItemNum = 100 
    elseif ( rnum == 4 )  then
        nNewItemID = 2000006 
        nNewItemNum = 50 
    elseif ( rnum == 5 )  then
        nNewItemID = 2022000 
        nNewItemNum = 15 
    elseif ( rnum == 6 )  then
        nNewItemID = 2022003 
        nNewItemNum = 15 
    elseif ( rnum == 7 )  then
        nNewItemID = 2040002 
        nNewItemNum = 1 
    elseif ( rnum == 8 )  then
        nNewItemID = 2040402 
        nNewItemNum = 1 
    elseif ( rnum == 9 )  then
        nNewItemID = 2040502 
        nNewItemNum = 1 
    elseif ( rnum == 10 )  then
        nNewItemID = 2040505 
        nNewItemNum = 1 
    elseif ( rnum == 11 )  then
        nNewItemID = 2040602 
        nNewItemNum = 1 
    elseif ( rnum == 12 )  then
        nNewItemID = 2040802 
        nNewItemNum = 1 
    elseif ( rnum == 13 )  then
        nNewItemID = 4003000 
        nNewItemNum = 30 
    elseif ( rnum == 14 )  then
        nNewItemID = 4010000 
        nNewItemNum = 8 
    elseif ( rnum == 15 )  then
        nNewItemID = 4010001 
        nNewItemNum = 8 
    elseif ( rnum == 16 )  then
        nNewItemID = 4010002 
        nNewItemNum = 8 
    elseif ( rnum == 17 )  then
        nNewItemID = 4010003 
        nNewItemNum = 8 
    elseif ( rnum == 18 )  then
        nNewItemID = 4010004 
        nNewItemNum = 8 
    elseif ( rnum == 19 )  then
        nNewItemID = 4010005 
        nNewItemNum = 8 
    elseif ( rnum == 20 )  then
        nNewItemID = 4010006 
        nNewItemNum = 5 
    elseif ( rnum == 21 )  then
        nNewItemID = 4020000 
        nNewItemNum = 8 
    elseif ( rnum == 22 )  then
        nNewItemID = 4020001 
        nNewItemNum = 8 
    elseif ( rnum == 23 )  then
        nNewItemID = 4020002 
        nNewItemNum = 8 
    elseif ( rnum == 24 )  then
        nNewItemID = 4020003 
        nNewItemNum = 8 
    elseif ( rnum == 25 )  then
        nNewItemID = 4020004 
        nNewItemNum = 8 
    elseif ( rnum == 26 )  then
        nNewItemID = 4020005 
        nNewItemNum = 8 
    elseif ( rnum == 27 )  then
        nNewItemID = 4020006 
        nNewItemNum = 8 
    elseif ( rnum == 28 )  then
        nNewItemID = 4020007 
        nNewItemNum = 3 
    elseif ( rnum == 29 )  then
        nNewItemID = 4020008 
        nNewItemNum = 3 
    elseif ( rnum == 30 )  then
        nNewItemID = 1032002 
        nNewItemNum = 1 
    elseif ( rnum == 31 )  then
        nNewItemID = 1032004 
        nNewItemNum = 1 
    elseif ( rnum == 32 )  then
        nNewItemID = 1032005 
        nNewItemNum = 1 
    elseif ( rnum == 33 )  then
        nNewItemID = 1032006 
        nNewItemNum = 1 
    elseif ( rnum == 34 )  then
        nNewItemID = 1032007 
        nNewItemNum = 1 
    elseif ( rnum == 35 )  then
        nNewItemID = 1032009 
        nNewItemNum = 1 
    elseif ( rnum == 36 )  then
        nNewItemID = 1032010 
        nNewItemNum = 1 
    elseif ( rnum == 37 )  then
        nNewItemID = 1002026 
        nNewItemNum = 1 
    elseif ( rnum == 38 )  then
        nNewItemID = 1002089 
        nNewItemNum = 1 
    elseif ( rnum == 39 )  then
        nNewItemID = 1002090 
        nNewItemNum = 1 
    end
    if(inventory->exchange(0, nNewItemID, nNewItemNum) ~= 0) then
        self->say("請確保您的背包還有足夠的欄位空間。")
    else
        target->transferField(103000805, "")
    end
    return
end

if(quest->getVar("stage") == "clear") then party1_reward() return end
if(target->isPartyBoss() == 1) then
    if(fieldID == 103000800) then
        party1_stage1()
    elseif(fieldID == 103000801) then
        party1_stage2()
    elseif(fieldID == 103000802) then
        party1_stage3()
    elseif(fieldID == 103000803) then
        party1_stage4()
    elseif(fieldID == 103000804) then
        party1_stage5()
    end
else
    if(fieldID == 103000800) then
        party1_personal()
    else party1_help() end
end