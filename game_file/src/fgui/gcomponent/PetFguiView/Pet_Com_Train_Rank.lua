local baseComponent = require("fgui.base.baseComponent")
local Pet_Com_Train_Rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Com_Train_Rank", Pet_Com_Train_Rank)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Pet_Com_Train_Rank:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btn_Advance_ten:addClickEventListener(handler(self, self.btnAdvanceAllClickCallBack), 10)
	self.fields.btn_Advance_ten:setTitle(i18n("common_text_2921"))
	self.fields.btn_Advance_ten:setCostIcon("5028.png")
end
function Pet_Com_Train_Rank:onShow()
end
function Pet_Com_Train_Rank:initData(petData, isHideRedPoint)
	self.petData = petData
	local needExp = petData.nextRankExp - petData.curRankExp
	local singleExp = backpackltCtrl:getPetAdvancedEXP(502801)
	local needCost = math.ceil(needExp / singleExp)
	local haveCount = backpackCtrl:getItemCount(502801)
	local useCount = needCost
	self.haveCount = haveCount
	self.useCount = useCount
	self.fields.btn_Advance_ten:setCostNum(useCount, haveCount, true)
	self.fields.btn_Advance_ten:showRedPoint(isHideRedPoint and self.haveCount >= self.useCount)
end
function Pet_Com_Train_Rank:btnAdvanceAllClickCallBack(button, type)
	SoraDPlaySound()
	local useCount = self.useCount
	if 0 < useCount and useCount <= self.haveCount then
		local count = useCount <= self.haveCount and useCount or self.haveCount
		_ENV = nil
		;(nil).count = count
		_ENV = nil
		;(nil).isNeedJudge = false
		;(nil).icon = itemDesRead.getIcon(502801)
		;(nil).width = 40
		SoraDShowBuyBox(i18n("common_text_2941", nil), count, i18n("common_text_2922"), function(callBack, data)
			if callBack == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				local unShare = data.isCheck
				petCtrl:setIsUnSharePet(unShare)
				if self.petData.curRankExp / 10 + useCount ~= self.petData.nextRankExp / 10 then
					petCtrl:reqAdvancePet(self.petData.petid, 502801, gPetAdvanceType.ONEKEY, unShare)
				else
					petCtrl:reqAdvancePet(self.petData.petid, 502801, gPetAdvanceType.ONEKEY, unShare)
				end
			end
		end, nil, nil, nil, nil, nil, i18n("pet_sharing_text1"), petCtrl:getIsUnSharePet())
	else
		self:needPetCoin()
	end
end
function Pet_Com_Train_Rank:btnAdvanceClickCallBack(button, type)
	SoraDPlaySound()
	if self.haveCount > 0 then
		if self.petData.curRankExp / 10 + 1 ~= self.petData.nextRankExp / 10 then
			petCtrl:reqAdvancePet(self.petData.petid, 502801, gPetAdvanceType.NORMAL)
		else
			petCtrl:reqAdvancePet(self.petData.petid, 502801, gPetAdvanceType.NORMAL)
		end
	else
		self:needPetCoin()
	end
end
function Pet_Com_Train_Rank:needPetCoin()
	local backpackltCtrl, otherData
	local singleExp = backpackltCtrl:getPetAdvancedEXP(502801)
	local maxValueCoin = self.petData.nextRankExp / singleExp
	local curValueCoin = self.petData.curRankExp / singleExp
	local maxCount = maxValueCoin - curValueCoin
	maxCount = math.max(1, maxCount)
	otherData.maxCount = maxCount
	otherData.curValue = maxCount
	backpackltCtrl = nil
	;(nil).itemID = 502801
	;(nil).otherData = otherData
	uiManager:show("CommonSourceGuide", nil)
end
function Pet_Com_Train_Rank:gameGuide_getTarget(itemName, parameters)
	if itemName == "CCS_commonGoldNormalBtn_advance" then
		return self.fields.btn_Advance_ten
	end
	return SoraDGetChildByName(self, itemName)
end
return Pet_Com_Train_Rank
