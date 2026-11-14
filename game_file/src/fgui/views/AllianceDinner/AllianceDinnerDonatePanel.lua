local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceDinnerCtrl = SoraDGetCtrl("allianceDinnerCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local AllianceDinnerDonatePanel = class("AllianceDinnerDonatePanel", baseFguiPanel)
function AllianceDinnerDonatePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHidePrePanel = false
	print("AllianceDinnerDonatePanel:ctor", self.viewName)
end
function AllianceDinnerDonatePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceDinnerDonatePanel:onInit()
	_ENV, _ENV = nil, nil
	;(nil).icon = "icon_sycb_c1.png"
	;(nil).ani = "sycb_shine_4"
	;(nil).aniscale = 1.4
	;(nil).aniFixPos = cc.p(6, 47)
	_ENV, (nil)[1], (nil).fixPos = nil, nil, cc.p(110, 50)
	;(nil).icon = "icon_sycb_c2.png"
	;(nil).ani = "sycb_shine_2"
	;(nil).aniscale = 1.4
	;(nil).aniFixPos = cc.p(3, 76)
	_ENV, (nil)[2], (nil).fixPos = nil, nil, cc.p(28, 50)
	;(nil).icon = "icon_sycb_c3.png"
	;(nil).ani = "sycb_shine_5"
	;(nil).aniscale = 1.4
	;(nil).aniFixPos = cc.p(0, 58)
	_ENV, (nil)[3], (nil).fixPos = nil, nil, cc.p(25, 30)
	;(nil).icon = "icon_sycb_c4.png"
	;(nil).ani = "sycb_shine_3"
	;(nil).aniscale = 1.4
	;(nil).aniFixPos = cc.p(0, 50)
	_ENV, (nil)[4], (nil).fixPos = nil, nil, cc.p(40, 30)
	;(nil).icon = "icon_sycb_c5.png"
	;(nil).ani = "sycb_shine_1"
	;(nil).aniscale = 1.0
	;(nil).aniFixPos = cc.p(0, 0)
	self.icons, (nil)[5], (nil).fixPos = nil, nil, cc.p(7, 0)
	print("=======AllianceDinnerDonatePanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001500"), handler(self, self.onClickClose))
	self.fields.list1:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.button_donate:setTitle(i18n("common_text_284"))
	self.fields.button_donate:addClickEventListener(handler(self, self.onDonateClick))
end
function AllianceDinnerDonatePanel:onShow()
	print("=======AllianceDinnerDonatePanel:onShow")
	self.index = self.param.index
	self.dinnerCfg = allianceDinnerCtrl:getDinnerCfg(self.index)
	self.dinnerIdx = self.dinnerCfg.index
	self.fields.txt_name:setString(i18n(self.dinnerCfg.dishName))
	self.itemId1 = self.dinnerCfg.dishNeed[1].id
	self.needNum1 = self.dinnerCfg.dishNeed[1].count
	self.itemId2 = self.dinnerCfg.dishNeed[2].id
	self.needNum2 = self.dinnerCfg.dishNeed[2].count
	self.fields.item1:initData(self.itemId1)
	self.fields.item2:initData(self.itemId2)
	self.fields.item_name1:setString(i18n(publicRead.getName(self.itemId1)))
	self.fields.item_name2:setString(i18n(publicRead.getName(self.itemId2)))
	local iconData = self.icons[self.index]
	self.fields.Effect_1:setEffectPath(iconData.ani)
	self.fields.Effect_1:setScale(self.fields.Effect_1:getScale() * iconData.aniscale)
	self.fields.Effect_1:setPosition(self.fields.Effect_1:getX() + iconData.aniFixPos.x, self.fields.Effect_1:getY() + iconData.aniFixPos.y)
	self.fields.icon:setURL(iconData.icon)
	self.fields.icon:setPosition(self.fields.icon:getX() + iconData.fixPos.x, self.fields.icon:getY() + iconData.fixPos.y)
	self.fields.title2:setTitle(i18n("Alliance_dinner_05"))
	self:updateView()
end
function AllianceDinnerDonatePanel:updateView()
	self.dinnerData = allianceDinnerCtrl:getDinnerData(self.dinnerIdx)
	local mergeCount = self.dinnerData.mergeCount or 0
	local isFirst = self.dinnerData.mergeCount == nil or self.dinnerData.mergeCount == 0
	self.oldMergeCount = mergeCount
	if isFirst then
		self.rewards = self.dinnerCfg.firstReward
		allianceDinnerCtrl = nil
		;(nil).var = i18n(self.dinnerCfg.dishName)
		self.fields.title1:setTitle(i18n("Alliance_dinner_10", nil))
	else
		self.rewards = self.dinnerCfg.reward
		allianceDinnerCtrl = i18n("Alliance_dinner_10", nil)
		i18n("Alliance_dinner_10", nil).var = i18n(self.dinnerCfg.dishName)
		self.fields.title1:setTitle(i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))
	end
	self.fields.list1:setNumItems(#self.rewards)
	self.haveNum1 = backpackCtrl:getItemCount(self.itemId1)
	self.haveNum2 = backpackCtrl:getItemCount(self.itemId2)
	allianceDinnerCtrl = i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))
	i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)).num = self.haveNum1
	self.fields.item_have1:setString(i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))
	allianceDinnerCtrl = i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))
	i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))).num = self.haveNum2
	self.fields.item_have2:setString(i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))))
	self.itemNum1 = self.dinnerData[tostring(self.itemId1)] or 0
	self.itemNum2 = self.dinnerData[tostring(self.itemId2)] or 0
	local color1 = self.itemNum1 < self.needNum1 and cc.c3b(190, 30, 30) or cc.c3b(215, 195, 155)
	local color2 = self.itemNum2 < self.needNum2 and cc.c3b(190, 30, 30) or cc.c3b(215, 195, 155)
	allianceDinnerCtrl = i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))
	i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))).num1 = self.itemNum1
	allianceDinnerCtrl, allianceDinnerCtrl, i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))).num2 = i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))
	self.needNum1.num1, i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))).color = i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))
	self.fields.item_num1:setString(i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))))
	allianceDinnerCtrl = i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))))
	i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))).num1 = self.itemNum2
	allianceDinnerCtrl, allianceDinnerCtrl, i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))).num2 = i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))))
	self.needNum2.num1, i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil))))).color = i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))))
	self.fields.item_num2:setString(i18n_html("%{num1}/%{num2}", i18n_html("%{num1}/%{num2}", i18n("common_text_531", i18n("common_text_531", i18n("Alliance_dinner_04", i18n("Alliance_dinner_10", nil)))))))
end
function AllianceDinnerDonatePanel:onItemRenderer(index, object)
	local data = self.rewards[index + 1]
	object:initData(data.id, data.count)
end
function AllianceDinnerDonatePanel:onDonateClick()
	SoraDPlaySound()
	if self.haveNum1 > 0 and self.itemNum1 < self.needNum1 or 0 < self.haveNum2 and self.itemNum2 < self.needNum2 then
		allianceDinnerCtrl:reqreqAllianceDinnerDonate(self.dinnerIdx)
		if self.haveNum1 > 0 and self.itemNum1 < self.needNum1 then
			self.fields.Effect_2:clearEffect()
			self.fields.Effect_2:setIsLoop(false)
			self.fields.Effect_2:setEffectPath("sycb_cook_left")
			self.fields.Effect_2:runAction(ffa.seq(ffa.delay(1.0), ffa.callFunc(function()
				self.fields.Effect_2:clearEffect()
			end)))
			SoraDPlaySound("normalcontrol", 5)
		end
		if 0 < self.haveNum2 and self.itemNum2 < self.needNum2 then
			self.fields.Effect_3:clearEffect()
			self.fields.Effect_3:setIsLoop(false)
			self.fields.Effect_3:setEffectPath("sycb_cook_right")
			self.fields.Effect_3:runAction(ffa.seq(ffa.delay(1.0), ffa.callFunc(function()
				self.fields.Effect_3:clearEffect()
			end)))
			SoraDPlaySound("normalcontrol", 5)
		end
	else
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	end
end
return AllianceDinnerDonatePanel
