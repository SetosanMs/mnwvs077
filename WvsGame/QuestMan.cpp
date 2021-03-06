#include "QuestMan.h"
#include "..\WvsLib\Wz\WzResMan.hpp"
#include "..\WvsLib\Memory\MemoryPoolMan.hpp"
#include "ActItem.h"
#include "ActQuest.h"
#include "ActSP.h"
#include "ActSkill.h"
#include "QuestAct.h"
#include "QuestDemand.h"

#include "..\Database\GA_Character.hpp"
#include "..\Database\GW_CharacterLevel.h"
#include "..\Database\GW_CharacterStat.h"
#include "User.h"
#include "Field.h"
#include "QWUQuestRecord.h"
#include "SkillInfo.h"

QuestMan::QuestMan()
{
}


QuestMan::~QuestMan()
{
}

void QuestMan::LoadAct()
{
	auto &actImg = stWzResMan->GetWz(Wz::Quest)["Act"];
	for (auto& questImg : actImg)
		RegisterAct(&questImg);
}

void QuestMan::LoadDemand()
{
	auto &demandImg = stWzResMan->GetWz(Wz::Quest)["Check"];
	for (auto& questImg : demandImg)
		RegisterDemand(&questImg);

	auto &questInfoImg = stWzResMan->GetWz(Wz::Quest)["QuestInfo"];
	for (auto& questImg : questInfoImg)
		if ((int)questImg["autoStart"] == 1)
			m_mAutoStartQuest.insert(atoi(questImg.GetName().c_str()));
		else if ((int)questImg["autoComplete"] == 1)
			m_mAutoCompleteQuest.insert(atoi(questImg.GetName().c_str()));
}

void QuestMan::RegisterAct(void * pProp)
{
	auto& actImg = *((WzIterator*)pProp);
	unsigned short nQuestID = atoi(actImg.GetName().c_str());
	for (auto& actNode : actImg)
	{
		QuestAct *pAct = AllocObj(QuestAct);
		pAct->nEXP = actNode["exp"];
		pAct->nCraftEXP = actNode["craftEXP"];
		pAct->nCharismaEXP = actNode["charismaEXP"];
		pAct->nCharmEXP = actNode["charmEXP"];
		pAct->nInsightEXP = actNode["insightEXP"];
		pAct->nSenseEXP = actNode["senseEXP"];
		pAct->nWillEXP = actNode["willEXP"];
		pAct->nPOP = actNode["pop"];
		pAct->nMoney = actNode["money"];
		pAct->nBuffItemID = actNode["buffItemID"];
		pAct->nTransferField = actNode["transferField"];
		pAct->nNextQuest = actNode["nextQuest"];
		pAct->sInfo = actNode["info"];

		auto& itemNode = actNode["item"];
		for (auto& itemAct : itemNode)
		{
			ActItem *pActItem = AllocObj(ActItem);
			pActItem->nItemID = itemAct["id"];
			pActItem->nCount = itemAct["count"];
			pActItem->nJob = itemAct["job"];
			pActItem->nJobEx = itemAct["jobEx"];
			pActItem->nPeriod = itemAct["period"];
			pActItem->nProp = itemAct["prop"];
			pActItem->nGender = 2;
			if ((int)itemAct["gender"])
				pActItem->nGender = itemAct["gender"];
			//pActItem->strPotentialGrade = (std::string)itemAct["potentialGrade"];
			pAct->aActItem.push_back(pActItem);
		}

		auto& spNode = actNode["sp"];
		for (auto& spAct : spNode)
		{
			ActSP *pActSP = AllocObj(ActSP);
			pActSP->nSPValue = spAct["sp_value"];
			for (auto& applyJob : spAct)
				pActSP->aJob.push_back((int)applyJob);
			pAct->aActSP.push_back(pActSP);
		}

		auto& skillNode = actNode["skill"];
		for (auto& skillAct : skillNode)
		{
			ActSkill *pActSkill = AllocObj(ActSkill);
			pActSkill->nSkillID = skillAct["id"];
			pActSkill->nMasterLevel = skillAct["masterLevel"];
			pActSkill->nSkillLevel = skillAct["skillLevel"];
			pAct->aActSkill.push_back(pActSkill);
		}

		auto& questNode = actNode["quest"];
		for (auto& questAct : questNode)
		{
			ActQuest *pActQuest = AllocObj(ActQuest);
			pActQuest->nQuestID = questAct["id"];
			pActQuest->nState = questAct["state"];
			pAct->aActQuest.push_back(pActQuest);
		}

		if (actNode.GetName() == "0")
			m_mStartAct.insert({ nQuestID, pAct });
		else if (actNode.GetName() == "1")
			m_mCompleteAct.insert({ nQuestID, pAct });
		else if (pAct != nullptr)
			FreeObj(pAct);
	}
}

void QuestMan::RegisterDemand(void * pProp)
{
	auto& demandImg = *((WzIterator*)pProp);
	unsigned short nQuestID = atoi(demandImg.GetName().c_str());
	for (auto& demandNode : demandImg)
	{
		QuestDemand *pDemand = AllocObj(QuestDemand);
		pDemand->nPartyQuest_S = demandNode["paryQuest_S"];
		pDemand->nDayByDay = demandNode["dayByDay"];
		pDemand->nNormalAutoStart = demandNode["normalAutoStart"];
		pDemand->nSubJobFlags = demandNode["subJobFlags"];
		
		pDemand->nPetTamenessMin = demandNode["pettamenessmin"];
		pDemand->nNpc = demandNode["npc"];
		pDemand->nQuestComplete = demandNode["questComplete"];
		pDemand->nPOP = demandNode["pop"];
		pDemand->nInterval = demandNode["interval"];
		pDemand->nLVMax = demandNode["lvmax"];
		pDemand->nLVMin = demandNode["lvmin"];
		pDemand->sStartScript = demandNode["startscript"];
		pDemand->sEndScript = demandNode["endscript"];

		auto& fieldNode = demandNode["fieldEnter"];
		for (auto& fieldDemand : fieldNode)
			pDemand->m_aFieldEnter.push_back((int)fieldDemand);

		auto& questNode = demandNode["quest"];
		for (auto& questDemand : questNode)
			pDemand->m_mDemandQuest[questDemand["id"]] = questDemand["state"];

		auto& itemNode = demandNode["item"];
		for (auto& itemDemand : itemNode) 
		{
			m_mItemQuest[itemDemand["id"]] = nQuestID;
			pDemand->m_mDemandItem[itemDemand["id"]] = itemDemand["count"];
		}
		
		auto& jobNode = demandNode["job"];
		for (auto& jobDemand : jobNode)
			pDemand->m_aDemandJob.push_back((int)jobDemand);

		auto& petNode = demandNode["pet"];
		for (auto& petDemand : petNode)
			pDemand->m_aDemandPet.push_back((int)petDemand);

		auto& mobNode = demandNode["mob"];
		for (auto& mobDemand : mobNode) 
		{
			m_mMobQuest[(int)mobDemand["id"]].push_back(nQuestID);
			pDemand->m_aDemandMob.push_back((int)mobDemand["id"]);
			pDemand->m_mDemandMob[mobDemand["id"]] = mobDemand["count"];
		}

		auto& skillNode = demandNode["skill"];
		for (auto& skillDemand : skillNode)
			pDemand->m_mDemandSkill[skillDemand["id"]] = ((std::string)skillDemand["level"] == "" ? 1 : (int)skillDemand["level"]);

		if (demandNode.GetName() == "0")
			m_mStartDemand.insert({ nQuestID, pDemand });
		else if (demandNode.GetName() == "1")
			m_mCompleteDemand.insert({ nQuestID, pDemand });
		else if (pDemand != nullptr)
			FreeObj(pDemand);
	}
}

QuestMan * QuestMan::GetInstance()
{
	static QuestMan* pInstance = new QuestMan;
	return pInstance;
}

bool QuestMan::IsAutoStartQuest(int nQuestID)
{
	auto findIter = m_mAutoStartQuest.find(nQuestID);
	return findIter != m_mAutoStartQuest.end();
}

bool QuestMan::IsAutoCompleteQuest(int nQuestID)
{
	auto findIter = m_mAutoCompleteQuest.find(nQuestID);
	return findIter != m_mAutoCompleteQuest.end();
}

bool QuestMan::CheckStartDemand(int nQuestID, User * pUser)
{
	if (QWUQuestRecord::GetState(pUser, nQuestID) != 0)
		return false;

	auto findIter = m_mStartDemand.find(nQuestID);
	if (findIter == m_mStartDemand.end())
		return false;
	auto pDemand = findIter->second;

	//Check level req.
	int nLevel = pUser->GetCharacterData()->mLevel->nLevel;
	if ((pDemand->nLVMax != 0 && nLevel > pDemand->nLVMax) ||
		(pDemand->nLVMin != 0 && nLevel < pDemand->nLVMin))
		return false;

	//Check field req.
	bool bCheck = pDemand->m_aFieldEnter.size() == 0 ? true : false;
	for(auto& field : pDemand->m_aFieldEnter)
		if (pUser->GetField()->GetFieldID() == field)
		{
			bCheck = true;
			break;
		}
	if (!bCheck)
		return false;

	//Check job req.
	bCheck = pDemand->m_aDemandJob.size() == 0 ? true : false;
	for (auto& job : pDemand->m_aDemandJob)
		if (pUser->GetCharacterData()->mStat->nJob == job)
		{
			bCheck = true;
			break;
		}
	if (!bCheck)
		return false;

	//Check quest req.
	for (auto& quest : pDemand->m_mDemandQuest)
		if (QWUQuestRecord::GetState(pUser, quest.first) < quest.second)
			return false;

	//Check skill req.
	for (auto& skill : pDemand->m_mDemandSkill)
		if (SkillInfo::GetInstance()->GetSkillLevel(
			pUser->GetCharacterData(),
			skill.second,
			nullptr,
			false,
			false,
			false,
			false) < skill.second)
			return false;

	//Check item req.
	for (auto& item : pDemand->m_mDemandItem)
	{
		auto nCount = pUser->GetCharacterData()->GetItemCount(item.first / 1000000, item.first);
		if (nCount < item.second)
			return false;
	}
	return true;
}

bool QuestMan::CheckCompleteDemand(int nQuestID, User * pUser)
{
	if (QWUQuestRecord::GetState(pUser, nQuestID) != 1)
		return false;

	auto findIter = m_mCompleteDemand.find(nQuestID);
	if (findIter == m_mCompleteDemand.end())
		return false;
	auto pDemand = findIter->second;

	//Check level req.
	int nLevel = pUser->GetCharacterData()->mLevel->nLevel;
	if ((pDemand->nLVMax != 0 && nLevel > pDemand->nLVMax) ||
		(pDemand->nLVMin != 0 && nLevel < pDemand->nLVMin))
		return false;

	//Check field req.
	bool bCheck = pDemand->m_aFieldEnter.size() == 0 ? true : false;
	for (auto& field : pDemand->m_aFieldEnter)
		if (pUser->GetField()->GetFieldID() == field)
		{
			bCheck = true;
			break;
		}
	if (!bCheck)
		return false;

	//Check job req.
	bCheck = pDemand->m_aDemandJob.size() == 0 ? true : false;
	for (auto& job : pDemand->m_aDemandJob)
		if (pUser->GetCharacterData()->mStat->nJob == job)
		{
			bCheck = true;
			break;
		}
	if (!bCheck)
		return false;

	//Check mount count records.
	for (int i = 0; i < (int)pDemand->m_aDemandMob.size(); ++i)
		if (QWUQuestRecord::GetMobCount(pUser, nQuestID, i) < pDemand->m_mDemandMob[pDemand->m_aDemandMob[i]])
			return false;

	//Check quest req.
	for (auto& quest : pDemand->m_mDemandQuest)
		if (QWUQuestRecord::GetState(pUser, quest.first) < quest.second)
			return false;

	//Check skill req.
	for (auto& skill : pDemand->m_mDemandSkill)
		if (SkillInfo::GetInstance()->GetSkillLevel(
			pUser->GetCharacterData(),
			skill.second,
			nullptr,
			false,
			false,
			false,
			false) < skill.second)
			return false;

	//Check item req.
	for (auto& item : pDemand->m_mDemandItem)
	{
		auto nCount = pUser->GetCharacterData()->GetItemCount(item.first / 1000000, item.first);
		if (nCount < item.second)
			return false;
	}
	return true;
}

QuestAct * QuestMan::GetStartAct(int nQuestID)
{
	auto findIter = m_mStartAct.find(nQuestID);
	return findIter != m_mStartAct.end() ? findIter->second : nullptr;
}

QuestAct * QuestMan::GetCompleteAct(int nQuestID)
{
	auto findIter = m_mCompleteAct.find(nQuestID);
	return findIter != m_mCompleteAct.end() ? findIter->second : nullptr;
}

QuestDemand * QuestMan::GetStartDemand(int nQuestID)
{
	auto findIter = m_mStartDemand.find(nQuestID);
	return findIter != m_mStartDemand.end() ? findIter->second : nullptr;
}

QuestDemand * QuestMan::GetCompleteDemand(int nQuestID)
{
	auto findIter = m_mCompleteDemand.find(nQuestID);
	return findIter != m_mCompleteDemand.end() ? findIter->second : nullptr;
}

int QuestMan::GetQuestByItem(int nItemID)
{
	auto findIter = m_mItemQuest.find(nItemID);
	if (findIter == m_mItemQuest.end())
		return 0;

	return findIter->second;
}

const std::vector<int>& QuestMan::GetQuestByMob(int nMobID)
{
	static std::vector<int> aEmpty;
	auto findIter = m_mMobQuest.find(nMobID);
	if (findIter == m_mMobQuest.end())
		return aEmpty;
	return findIter->second;
}
