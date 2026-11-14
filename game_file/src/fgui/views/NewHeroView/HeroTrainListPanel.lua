local gametop = gModuleMgr.getObject("gametop")
local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTrainListPanel = class("HeroTrainListPanel", baseFguiPanel)
function HeroTrainListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroTrainListPanel:ctor", self.viewName)
end
function HeroTrainListPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroTrainListPanel:onInit()
	print("=======HeroTrainListPanel:onInit")
	self.fields.title:initData(i18n("buildDes_name_123"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function HeroTrainListPanel:onItemRederer(index, target)
	local position = self.trainList[index + 1] and self.trainList[index + 1].position
	local isGain = false
	if self.gainPid and position and position == self.gainPid then
		isGain = true
	end
	target:initData(self.trainList[index + 1], isGain)
end
function HeroTrainListPanel:onShow()
	print("=======HeroTrainListPanel:onShow")
	SoraDShowLoading()
	heroTrainGroundCtrl:initReq()
end
function HeroTrainListPanel:initData(redata)
	if redata and redata.position and redata.isGain then
		self.gainPid = redata.position
	else
		self.gainPid = nil
	end
	SoraDCloseLoading()
	self.trainList = heroTrainGroundCtrl:getTrainInfo()
	dump(self.trainList, "self.trainList")
	self:initView()
end
function HeroTrainListPanel:initView()
	local showNum = math.min(#self.trainList + 1, gHeroTrainSite)
	self.fields.List:setNumItems(showNum)
	self:refreshText()
end
function HeroTrainListPanel:refreshText(...)
	local _cur, _total = heroTrainGroundCtrl:getTrainNumState()
	heroTrainGroundCtrl = nil
	;(nil).num = _cur
	;(nil).neednum = _total
	self.fields.Text_num:setString(i18n("herotrain_text_05", nil))
	heroTrainGroundCtrl = i18n("herotrain_text_05", nil)
	local ret = heroTrainGroundCtrl:getHourLeaderPoint(i18n("herotrain_text_05", nil))
	heroTrainGroundCtrl = i18n("herotrain_text_05", nil)
	heroTrainGroundCtrl, heroTrainGroundCtrl, i18n("herotrain_text_05", nil).num = i18n("herotrain_text_05", nil)
	heroTrainGroundCtrl, (ret.add * 100).num, i18n("herotrain_text_05", nil).color = i18n("herotrain_text_05", nil)
	;(ret.add * 100).__default, i18n("herotrain_text_05", nil).color = i18n("herotrain_text_05", nil)
	self.fields.Text_add:setString(i18n_html("herotrain_text_06", i18n("herotrain_text_05", nil)))
end
function HeroTrainListPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_TRAIN)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.HERO_TRAIN)
	end
end
return HeroTrainListPanel
