
require "./DataSrv/Script/sysDef"

function wizQuestion(index)
{
    ::INCORRECT_ANSWER::
    if(errorReport == 1)
    {
        self->say("很遺憾，你答錯了，必須重新開始。");
        return;
    }
    errorReport = 1;

    if(index == 1)
    {
        ans = self->askMenu("問題一：從楓之谷一開始，遇到的第一個NPC是誰？#b\r\n#L0# #p2000##l\r\n#L1# #p1010100##l\r\n#L2# #p2101##l\r\n#L3# #p2001##l\r\n#L4# #p2102##l");
        if(ans != 2) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：下列中，在楓之島無法見到的怪物是哪一個？#b\r\n#L0# #o100101##l\r\n#L1# #o1210102##l\r\n#L2# #o130101##l\r\n#L3# #o1210100##l\r\n#L4# #o120100##l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：弓箭手村的瑪亞請求我們拿什麼物品給她，來治好她的病？#b\r\n#L0# 紅色藥水 #l\r\n#L1# #t4031654# #l\r\n#L2# #t2002011#  #l\r\n#L3# #t2002015# #l\r\n#L4# #t4031006##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：楓之谷下列藥品中，哪組藥品與效果是不正確對應關係的？#b\r\n#L0# #t2050003# - 解除所有異常狀態#l\r\n#L1# #t2020014# - MP 3000 回復#l\r\n#L2# #t2020004# - HP 400 回復#l\r\n#L3# #t2020000# - MP 200 回復#l\r\n#L4# #t2000003# - MP 100 回復#l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：下列中，在維多利亞島無法見到的怪物是哪一個？#b\r\n#L0# #o2110200##l\r\n#L1# #o2230100##l\r\n#L2# #o5130100##l\r\n#L3# #o2230101##l\r\n#L4# #o3000000##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
    }
    else if(index == 2)
    {
        ans = self->askMenu("問題一：下列中，在艾納斯島的阿爾法小隊中沒有的人物是誰？#b\r\n#L0# 皮特中士 #l\r\n#L1# #p2010000##l\r\n#L2# #p2020003##l\r\n#L3# #p2030002##l\r\n#L4# #p2030001##l");
        if(ans != 0) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：下列中，喚醒麥吉的舊戰劍不需要的材料是什麼？#b\r\n#L0# #t4003002##l\r\n#L1# #t4021009##l\r\n#L2# #t4001006##l\r\n#L3# #t4003003##l\r\n#L4# #t4001005##l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：下列中，在維多利亞島的墮落城市無法見到的NPC是誰？#b\r\n#L0# #p1052002##l\r\n#L1# #p1052102##l\r\n#L2# #p1052012##l\r\n#L3# #p1052100##l\r\n#L4# #p1040000##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：下列中，哪組怪物與打倒它所能得到的戰利品不吻合的是哪一個？#b\r\n#L0# #o3230200# - #t4000059##l\r\n#L1# #o4230105# - 食人花的葉子#l\r\n#L2# #o6130101# - #t4000040##l\r\n#L3# #o6130103# - #t4000050##l\r\n#L4# #o3210800# - #t4000029##l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：下列中，會飛的怪物是哪一個？#b\r\n#L0# #o5130104##l\r\n#L1# #o4230105##l\r\n#L2# #o4230103##l\r\n#L3# #o4130101##l\r\n#L4# #o5300100##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
    }
    else if(index == 3)
    {
        ans = self->askMenu("問題一：在維多利亞島的弓箭手村看不見的NPC是誰？\r\n#b#L0# #p1012101##l\r\n#L1# #p1002001##l\r\n#L2# #p1010100##l\r\n#L3# #p1012100##l\r\n#L4# #p1012102##l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：楓之谷中，從等級1到等級2需要多少經驗值？#b\r\n#L0# 10#l\r\n#L1# 15#l\r\n#L2# 20#l\r\n#L3# 25#l\r\n#L4# 30#l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：以下要求等級最高的任務是？#b\r\n#L0# 麥吉的舊戰劍 #l\r\n#L1# 守衛兵魯克的決心 #l\r\n#L2# 尋找古代之書 #l\r\n#L3# 亞凱斯特和黑暗水晶 #l\r\n#L4# 阿爾法部隊聯絡網 #l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：下列中，哪個職業不是2轉中出現的職業？#b\r\n#L0# 狂戰士#l\r\n#L1# 冰雷巫師#l\r\n#L2# 僧侶#l\r\n#L3# 魔導士#l\r\n#L4# 獵人#l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：下列中，可以重複執行的任務是？#b\r\n#L0# 幫助尤娜#l\r\n#L1# 狩獵菇菇寶貝#l\r\n#L2# 修理酋長的家#l\r\n#L3# 艾溫的玻璃鞋#l\r\n#L4# 長老的介紹#l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
    }
    else if(index == 4)
    {
        ans = self->askMenu("問題一：下列中，哪組怪物與打倒它所能得到的戰利品吻合的是哪一個？#b\r\n#L0# #o3210100# - 肥肥緞帶#l\r\n#L1# #o2300100# - #t4000042##l\r\n#L2# #o1210100# - 嫩寶殼#l\r\n#L3# #o4230100# - 龍之血#l\r\n#L4# #o2230101# - 菇菇孢牙#l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：下列中，在維多利亞島的勇士之村無法見到的NPC是誰？#b\r\n#L0# #p1021100##l\r\n#L1# #p1022100##l\r\n#L2# #p1022002##l\r\n#L3# #p1022003##l\r\n#L4# #p1032002##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：在墮落城市中，離家出走的少年阿勒斯的父親是誰？#b\r\n#L0# #p1012005##l\r\n#L1# #p1012002##l\r\n#L2# #p12000##l\r\n#L3# #p20000##l\r\n#L4# #p1012003##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：為了2轉而收集30個黑珠給轉職教官，從他那�堭o到什麼？#b\r\n#L0# #t4031012##l\r\n#L1# #t4031057##l\r\n#L2# #t4031058##l\r\n#L3# 長老的推薦信#l\r\n#L4# 冒險家勳章#l");
        if(ans != 0) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：根據不同職業的第1次轉職必須條件，正確且必須的是哪一個？#b\r\n#L0# 劍士 - 力量 30+#l\r\n#L1# 法師 - 智力 25+#l\r\n#L2# 弓箭手 - 敏捷 25+#l\r\n#L3# 盜賊 - 敏捷 20+#l\r\n#L4# 盜賊 - 力量 20+#l");
        if(ans != 2) { goto INCORRECT_ANSWER; }
    }
    else if(index == 5)
    {
        ans = self->askMenu("問題一：被怪物攻擊時特別的異常狀態沒有被正確說明的是哪一個？\r\n#b#L0# 黑暗——命中率下降 #l\r\n#L1# 詛咒——獲得的EXP減少 #l\r\n#L2# 虛弱——移動速度降低 #l\r\n#L3# 封印——無法使用技能 #l\r\n#L4# 中毒——緩慢減少HP #l");
        if(ans != 2) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：在艾納斯島沒有哪個怪物？#b\r\n#L0# #o5130103##l\r\n#L1# #o5140000##l\r\n#L2# #o6300000##l\r\n#L3# #o8140000##l\r\n#L4# #o5120000##l");
        if(ans != 0) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：下列中，在艾納斯島的冰原雪域無法見到的NPC是誰？#b\r\n#L0# #p2020000##l\r\n#L1# #p2020003##l\r\n#L2# #p2012010##l\r\n#L3# #p2020006##l\r\n#L4# #p2020007##l");
        if(ans != 2) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：下列不是進行合成、煉製、製作的NPC是哪一個？#b\r\n#L0# #p2010003##l\r\n#L1# #p1022003##l\r\n#L2# #p1032003##l\r\n#L3# #p1032002##l\r\n#L4# #p2020000##l");
        if(ans != 2) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：楓之谷下列藥品中，哪組藥品與效果是正確對應關係的？#b\r\n#L0# #t2000001# - HP 200 �庖_#l\r\n#L1# #t2001001# - MP 2000 �庖_#l\r\n#L2# #t2010004# - MP 100 �庖_#l\r\n#L3# #t2020001# - HP 300 �庖_#l\r\n#L4# #t2020003# - HP 400 �庖_#l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
    }
    else if(index == 6)
    {
        ans = self->askMenu("問題一：在維多利亞島的魔法森林看不見的NPC是誰？#b\r\n#L0# #p1032003##l\r\n#L1# #p1032002##l\r\n#L2# #p1032001##l\r\n#L3# #p1032100##l\r\n#L4# #p1081101##l");
        if(ans != 4) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題二：在艾納斯島的天空之城看不見的NPC是誰？#b\r\n#L0# #p2010000##l\r\n#L1# #p1022100##l\r\n#L2# #p2010003##l\r\n#L3# #p2012004##l\r\n#L4# #p2012005##l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題三：綠菇菇、木妖、藍水靈、斧木妖、三眼章魚，哪個是等級最高的怪物？#b\r\n#L0# 綠菇菇 #l\r\n#L1# 斧木妖 #l\r\n#L2# 藍水靈 #l\r\n#L3# 木妖 #l\r\n#L4# 三眼章魚 #l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題四：下列中，在維多利亞島沒有的村莊是？#b\r\n#L0# 奇幻村 #l\r\n#L1# 楓葉村 #l\r\n#L2# 勇士之村 #l\r\n#L3# 墮落城市 #l\r\n#L4# 魔法森林#l");
        if(ans != 1) { goto INCORRECT_ANSWER; }
        ans = self->askMenu("問題五：與寵物無關的NPC是誰？#b\r\n#L0# #p1012005##l\r\n#L1# #p1032102##l\r\n#L2# #p1012007##l\r\n#L3# #p1012002##l\r\n#L4# #p1012004##l");
        if(ans != 3) { goto INCORRECT_ANSWER; }
    }
    self->say("恭喜你完成了所有的測驗...你的智慧已經獲得檢驗...請把這個項鍊戴在身上然後回去。");
    if(inventory->exchange(0, 4031058, 1) != 0)
        self->say("不會吧？看��來你的其他欄位空間不足...");
}

if(target->getLevel() >= 70 and qr->get(7500) == "end1")
{
    if(inventory->itemCount(4031058) != 0)
        self->say("你還沒把項鍊帶回去給長老們嗎？");
    else if(self->askYesNo("... ... ...\r\n如果你想要通過智慧的考驗，你必須正確回答我所提出的問題，不過，在那之前，你必須交出#b#t4005004##k作為代價，你準備好了嗎？") == 1)
    {
        if(inventory->exchange(0, 4005004, -1) != 0)
            self->say("你身上沒有任何的#b#t4005004##k，我無法為你進行測驗...");
        else
        {
            self->say("那麼接下來我將開始智慧測驗。回答下列所有問題，那你就可以通過考驗。但是如果你回答錯了，或�芵桯牰℅嚏A那你必須重新來過...");
            wizQuestion(random(1, 6));
        }
    }
    else
        self->say("等你準備好時，再來與我談話。");
}