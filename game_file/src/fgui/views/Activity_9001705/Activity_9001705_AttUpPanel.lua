local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001705_AttUpPanel = class("Activity_9001705_AttUpPanel", baseFguiPanel)
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
function Activity_9001705_AttUpPanel:ctor(...)
	Activity_9001705_AttUpPanel.super.ctor(self, ...)
	print("Activity_9001705_AttUpPanel:ctor", self.viewName)
end
function Activity_9001705_AttUpPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001705_AttUpPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_1349"))
	self.fields.Button_up1:addClickEventListener(handler(self, self.onClickAttr), "power")
	self.fields.Button_up2:addClickEventListener(handler(self, self.onClickAttr), "speed")
	self.fields.Button_up3:addClickEventListener(handler(self, self.onClickAttr), "lucky")
end
function Activity_9001705_AttUpPanel:onShow()
	print("=======Activity_9001705_AttUpPanel:onShow")
	self:updateView()
end
function Activity_9001705_AttUpPanel:updateView()
	local level1, isCanUp1, nextExp1 = self.fields.Com_9001705_attr1:initData("power", true)
	local level2, isCanUp2, nextExp2 = self.fields.Com_9001705_attr2:initData("speed", true)
	local level3, isCanUp3, nextExp3 = self.fields.Com_9001705_attr3:initData("lucky", true)
	local isOtherLvEnough1 = level1 <= level2 and level1 <= level3
	local isOtherLvEnough2 = level1 >= level2 and level2 <= level3
	local isOtherLvEnough3 = level1 >= level3 and level2 >= level3
	if isCanUp1 and isOtherLvEnough1 then
		self.fields.Com_9001705_attr1:showNextLevel()
	end
	if isCanUp2 and isOtherLvEnough2 then
		self.fields.Com_9001705_attr2:showNextLevel()
	end
	if isCanUp3 and isOtherLvEnough3 then
		self.fields.Com_9001705_attr3:showNextLevel()
	end
	self.score = activity_9001705_Ctrl:getAttScore()
	activity_9001705_Ctrl = nil
	;(nil).num = self.score
	self.fields.text_score:setString(i18n("snow_competition_text_03", nil))
	dump(self.score, "Activity_9001705_AttUpPanel:updateView")
	_UPVALUE3_ = dump
	dump[1] = nextExp1
	dump[2] = nextExp2
	local dump[3], exps = nextExp3, dump
	for i, v in ipairs(exps) do
		local isMaxLv = v == 0
		self.fields["Button_up" .. i]:setEnabled(not isMaxLv)
		self.fields["text_btn_title" .. i]:setVisible(not isMaxLv)
		self.fields["text_btn_title2" .. i]:setVisible(not isMaxLv)
		self.fields["text_btn_title" .. i]:setColor(v <= self.score and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
		self.fields["text_btn_title2" .. i]:setColor(v <= self.score and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
		self.fields["Button_up" .. i]:setTitle(isMaxLv and i18n("common_text_283") or "")
		if not isMaxLv then
			activity_9001705_Ctrl = 0
			;(0).param = "#1696.png"
			;(0).name = "icon"
			;(0).width = 24
			;(0).height = 24
			;(0).custom = "Sprite"
			;(0).offsety = 2
			;(0).scale = 1.0
			self.fields["text_btn_title" .. i]:setString(v .. SoraDWrapReplaceTag(0))
			self.fields["text_btn_title2" .. i]:setString(i18n("Jinn_hatch_text_18"))
			print("not isMaxLv")
		end
	end
	activity_9001705_Ctrl, activity_9001705_Ctrl = ipairs(exps)
	ipairs(exps).canUp = isCanUp1
	ipairs(exps).exp = nextExp1
	activity_9001705_Ctrl, ipairs(exps).power, ipairs(exps).isOtherLvEnough = ipairs(exps)
	ipairs(exps).canUp = isCanUp2
	ipairs(exps).exp = nextExp2
	activity_9001705_Ctrl, ipairs(exps).speed, ipairs(exps).isOtherLvEnough = ipairs(exps)
	ipairs(exps).canUp = isCanUp3
	ipairs(exps).exp = nextExp3
	self.isCanUpMap, ipairs(exps).lucky, ipairs(exps).isOtherLvEnough = ipairs(exps)
	dump(self.isCanUpMap, "self.isCanUpMap")
end
function Activity_9001705_AttUpPanel:onClickAttr(sender, attr)
	SoraDPlaySound()
	local isCanUpData = self.isCanUpMap[attr]
	if not isCanUpData.canUp or not isCanUpData.isOtherLvEnough then
		if not isCanUpData.isOtherLvEnough then
			SoraDShowMsgTip(i18n("snow_competition_text_19"))
		else
			SoraDShowMsgTip(i18n("snow_competition_text_18"))
		end
		return
	end
	activity_9001705_Ctrl:reqSnowCompetitionUpgradeAttr(attr)
end
return Activity_9001705_AttUpPanel
