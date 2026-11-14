local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local intetiorUtil = include("intetiorUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorDonateGoldPanel = class("intetiorDonateGoldPanel", baseFguiPanel)
local TEN_TIMES = 10
local CONST_GOLD = 200
local CONST_GOLD_TEN = CONST_GOLD * TEN_TIMES
function intetiorDonateGoldPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorDonateGoldPanel:ctor", self.viewName)
end
function intetiorDonateGoldPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorDonateGoldPanel:onInit()
	print("=======intetiorDonateGoldPanel:onInit")
	self.fields.Panel_bg:setString(i18n("parliament_btn_13"))
	self.fields.Button_DonateOne:addClickListener(handler(self, self.btnDonateOneClickCallBack))
	self.fields.Button_DonateOne:setCost(gIDDef.GOLDBAR, CONST_GOLD)
	self.fields.Button_DonateOne:setCostIcon("icon_parliament_gold.png")
	_ENV = handler(self, self.btnDonateOneClickCallBack)
	handler(self, self.btnDonateOneClickCallBack).num = 1
	self.fields.Button_DonateOne:setString(i18n("parliament_text_21", handler(self, self.btnDonateOneClickCallBack)))
	self.fields.Button_DonateTen:addClickListener(handler(self, self.btnDonateTenClickCallBack))
	self.fields.Button_DonateTen:setCost(gIDDef.GOLDBAR, CONST_GOLD_TEN)
	self.fields.Button_DonateTen:setCostIcon("icon_parliament_gold.png")
	_ENV = handler(self, self.btnDonateTenClickCallBack)
	handler(self, self.btnDonateTenClickCallBack).num = 10
	self.fields.Button_DonateTen:setString(i18n("parliament_text_21", handler(self, self.btnDonateTenClickCallBack)))
	self.fields.Button_DonateTen:setGoldColor(cc.c3b(255, 251, 213))
	self.fields.Button_DonateOne:setGoldColor(cc.c3b(255, 251, 213))
	self.fields.Text_tips:setString(i18n("parliament_text_18"))
end
function intetiorDonateGoldPanel:onShow()
	print("=======intetiorDonateGoldPanel:onShow")
	self:initSkill(self.proxy.param)
	self.fields.Label_MyGold:getController("color1"):setSelectedIndex(1)
	self.fields.Label_KingGold:getController("color1"):setSelectedIndex(1)
end
function intetiorDonateGoldPanel:initSkill(skill)
	if next(skill) then
		self.skill = skill
	else
		self.skill = nil
	end
	self.fields.Label_KingGold:initSkill(self.skill)
end
function intetiorDonateGoldPanel:btnDonateOneClickCallBack()
	self:onDonate(false)
end
function intetiorDonateGoldPanel:btnDonateTenClickCallBack()
	self:onDonate(true)
end
local checkCanDonateGold = function(goldTime)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_25"))
		return false
	end
	if intetiorUtil:checkKingdomGoldFull() then
		SoraDShowMsgTip(i18n("parliament_text_23"))
		return false
	end
	goldTime = goldTime or CONST_GOLD
	if not intetiorUtil:checkEnoughGold(goldTime) then
		intetiorUtil:showGoldTips(goldTime)
		return false
	end
	return true
end
function intetiorDonateGoldPanel:sendMsg(gold)
	if self.skill then
		local id = self.skill:getSkillID()
		intetiorCtrl:reqParliamentPolicyDonate(id, gold)
	else
		intetiorCtrl:reqParliamentTreasuryDonate(gold)
	end
	SoraDShowLoading(self)
end
function intetiorDonateGoldPanel:onDonate(isTen)
	if self.skill and not self.skill:checkSkillCanDo_Doate() then
		self:removeFromParent()
		return
	end
	local gold = CONST_GOLD
	if checkCanDonateGold(gold) then
		if isTen and not intetiorUtil:checkEnoughGold(CONST_GOLD_TEN) then
			local mygold = intetiorCtrl:getMyGold()
			local times = math.floor(mygold / CONST_GOLD)
			gold = times * gold
			CONST_GOLD = nil
			;(nil).num = gold
			local showMsg = i18n("parliament_text_71", nil)
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
					self:sendMsg(gold)
				end
			end)
		else
			gold = isTen and CONST_GOLD_TEN or CONST_GOLD
			self:sendMsg(gold)
		end
	end
end
return intetiorDonateGoldPanel
