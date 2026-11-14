local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local resDesRead = include("resDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_seedInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_seedInfo", Com_seedInfo)
function Com_seedInfo:registerEvent()
end
function Com_seedInfo:onInit()
	local imageName = resDesRead.getIcon(gIDDef.BALL_FIELD_MATCH_EXP)
	self.fields.icon_exp:setURL(imageName)
	self.fields.Button_lvup:setTitle(i18n("football_match_text_055"))
	self.fields.Button_lvup:addClickListener(handler(self, self.onClick_Button_lvup))
	self.fields.Button_reset:setTitle(i18n("football_match_text_054"))
	self.fields.Button_reset:addClickListener(handler(self, self.onClick_Button_reset))
	self.fields.Button_sure:setTitle(i18n("football_match_text_060"))
	self.fields.Button_sure:addClickListener(handler(self, self.onClick_Button_sure))
	self.fields.Button_cancel:setTitle(i18n("football_match_text_059"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClick_Button_cancel))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.onSliderChangeBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Image_arrowLv:fix()
		self.fields.Image_arrowPower:fix()
	end
end
function Com_seedInfo:onShow()
	self.controllers.c1:setSelectedIndex(0)
end
function Com_seedInfo:onClick_Button_lvup(context)
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(1)
	self:updateComSlider()
end
function Com_seedInfo:updateComSlider()
	local totalExp = activity_9001736_Ctrl:getTotalExp()
	local seedQuality = self.data.quality
	local maxExp = activity_9001736_Read.getSeedMaxExp(seedQuality)
	local seedExp = activity_9001736_Ctrl:getSeedExp(self.data.id)
	local maxValue = math.min(totalExp, maxExp - seedExp)
	activity_9001736_Ctrl = nil
	;(nil).maxValue = maxValue
	;(nil).minValue = 0
	;(nil).curValue = 0
	;(nil).allowZero = true
	self.fields.Com_slider:initData(nil)
	local maxText = "/" .. totalExp
	self.fields.Com_slider:setMaxText(maxText)
end
function Com_seedInfo:onClick_Button_reset(context)
	SoraDPlaySound()
	local seedID = self.data.id
	local seedExp = activity_9001736_Ctrl:getSeedExp(seedID)
	if 0 < seedExp then
		activity_9001736_Ctrl = activity_9001736_Ctrl
		local activity_9001736_Ctrl[1], seedIdList = seedID, activity_9001736_Ctrl
		local content = i18n("football_match_text_057")
		if self.data.isIn then
			content = i18n("football_match_text_075")
		end
		_ENV = nil
		;(nil).content = content
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			activity_9001736_Ctrl:reqReset(seedIdList)
		end
		uiManager:show("MessageBox", nil)
	else
		SoraDShowMsgTip(i18n("football_match_text_056"))
	end
end
function Com_seedInfo:onClick_Button_sure(context)
	SoraDPlaySound()
	local addExp = self.addExp or 0
	if 0 < addExp then
		activity_9001736_Ctrl:reqUpLevel(self.data.id, addExp)
	end
end
function Com_seedInfo:onClick_Button_cancel(context)
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(0)
	self:updateSeedInfo()
end
function Com_seedInfo:initData(data)
	print("==Com_seedInfo:initData==", data.id)
	self.data = data
	self.fields.Com_seedItem:initData(data)
	if self.controllers.c1:getSelectedIndex() == 0 then
		self:updateSeedInfo()
	else
		self:updateComSlider()
	end
end
function Com_seedInfo:updateSeedInfo()
	self.controllers.c_next:setSelectedIndex(0)
	local seedID = self.data.id
	local seedName = activity_9001736_Read.getSeedName(seedID)
	self.fields.Text_name:setString(seedName)
	local seedLv = self.data.lv
	activity_9001736_Read = nil
	;(nil).lv = seedLv
	local curLvStr = i18n("common_text_100", nil)
	activity_9001736_Read = nil
	;(nil).num = curLvStr
	local seedLvStr = i18n("football_match_text_051", nil)
	self.fields.Text_lv:setString(seedLvStr)
	local seedQuality = activity_9001736_Read.getSeedQuality(seedID)
	local maxLv = activity_9001736_Read.getSeedMaxLv(seedQuality)
	if seedLv >= maxLv then
		activity_9001736_Read = nil
		activity_9001736_Read = nil
		;(nil).color = "#70C723"
		;(nil).num = SoraDWrapHtmlTagByStyle("MAX", nil)
		local seedExpStr = i18n("football_match_text_052", nil)
		self.fields.Text_exp:setString(seedExpStr)
	else
		local curLvExp = activity_9001736_Ctrl:getSeedCurLvExp(seedID)
		local lvupExp = activity_9001736_Ctrl:getSeedLvupExp(seedID)
		activity_9001736_Read = "MAX"
		;("MAX").member = curLvExp
		;("MAX").total = lvupExp
		local seedExpStr = i18n("common_text_155", "MAX")
		activity_9001736_Read = nil
		;(nil).num = seedExpStr
		seedExpStr = i18n("football_match_text_052", nil)
		self.fields.Text_exp:setString(seedExpStr)
	end
	local seedPower = self.data.power
	local powerStr = string.formatnumberthousands(seedPower)
	activity_9001736_Read = self.fields.Text_exp
	self.fields.Text_exp.num = powerStr
	local seedPowerStr = i18n("football_match_text_053", self.fields.Text_exp)
	self.fields.Text_power:setString(seedPowerStr)
end
function Com_seedInfo:onSliderChangeBack(addValue)
	print("==Com_seedInfo:onSliderChangeBack==", addValue)
	self.addExp = addValue or 0
	self:updateSeedUplvInfo()
end
function Com_seedInfo:updateSeedUplvInfo()
	self.controllers.c_next:setSelectedIndex(1)
	local addExp = self.addExp or 0
	local seedID = self.data.id
	local seedLv = self.data.lv
	local seedQuality = activity_9001736_Read.getSeedQuality(seedID)
	local maxLv = activity_9001736_Read.getSeedMaxLv(seedQuality)
	if seedLv >= maxLv then
		self:updateSeedInfo()
		return
	end
	local seedLv = self.data.lv
	local seedQuality = self.data.quality
	local seedExp = activity_9001736_Ctrl:getSeedExp(seedID)
	local nextTotalExp = seedExp + addExp
	local nextLv = activity_9001736_Read.getSeedLvByExp(seedQuality, nextTotalExp)
	local curLvExp = activity_9001736_Ctrl:getSeedCurLvExp(seedID)
	local lvupExp = activity_9001736_Ctrl:getSeedLvupExp(seedID)
	local activity_9001736_Read, style = activity_9001736_Ctrl, activity_9001736_Ctrl
	if 0 < addExp then
		activity_9001736_Read = seedID
		style.member, seedID.color = seedID, "#70C723"
	end
	local nextExp = curLvExp + addExp
	activity_9001736_Read = nil
	;(nil).member = nextExp
	;(nil).total = lvupExp
	local expStr = i18n_html("common_text_155", nil, style)
	activity_9001736_Read = style
	style.num = expStr
	local seedExpStr = i18n("football_match_text_052", style)
	if maxLv <= nextLv then
		activity_9001736_Read = nil
		;(nil).color = "#70C723"
		seedExpStr = seedExpStr .. " " .. SoraDWrapHtmlTagByStyle("MAX", nil)
	end
	self.fields.Text_exp:setString(seedExpStr)
	activity_9001736_Read = seedExpStr
	seedExpStr.lv = seedLv
	local curLvStr = i18n("common_text_100", seedExpStr)
	activity_9001736_Read = "MAX"
	;("MAX").lv = nextLv
	local nextLvStr = i18n("common_text_100", "MAX")
	if seedLv < nextLv then
		activity_9001736_Read = nil
		;(nil).color = "#70C723"
		nextLvStr = SoraDWrapHtmlTagByStyle(nextLvStr, nil)
	end
	activity_9001736_Read = nil
	;(nil).num = curLvStr
	local seedLvStr = i18n("football_match_text_051", nil)
	self.fields.Text_lv:setString(seedLvStr)
	self.fields.Text_nextLv:setString(nextLvStr)
	local seedPower = self.data.power
	local powerStr = string.formatnumberthousands(seedPower)
	local nextPowerStr = powerStr
	if seedLv < nextLv then
		local basePower = activity_9001736_Read.getSeedPower(seedID)
		local addPower = activity_9001736_Read.getSeedLvupPowerArise(seedQuality, nextLv)
		local nextPower = basePower + addPower
		activity_9001736_Read = nil
		;(nil).color = "#70C723"
		nextPowerStr = SoraDWrapHtmlTagByStyle(nextPower, nil)
	end
	activity_9001736_Read = basePower + addPower
	;(basePower + addPower).num = powerStr
	local seedPowerStr = i18n("football_match_text_053", basePower + addPower)
	self.fields.Text_power:setString(seedPowerStr)
	self.fields.Text_nextPower:setString(nextPowerStr)
end
function Com_seedInfo:onMsgUpLevel(target, event)
end
function Com_seedInfo:getCurShowSeedId()
	return self.data.id
end
function Com_seedInfo:getCurShowSeedLv()
	return self.data.lv
end
function Com_seedInfo:showEffect()
	self.fields.mv_item:setFrames("ssyj_effect_sj_%02d.png", 1)
end
return Com_seedInfo
