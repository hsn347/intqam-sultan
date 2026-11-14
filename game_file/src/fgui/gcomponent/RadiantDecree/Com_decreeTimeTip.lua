local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeTimeTip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeTimeTip", Com_decreeTimeTip)
function Com_decreeTimeTip:onInit()
	self:fixChildrenPos()
	self.fields.title = SoraDCreateTimerLabel(self, self.fields.title)
	self.fields.title:setTouchEnabled(true)
	self.fields.title:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
end
function Com_decreeTimeTip:initData(isStatue)
	if isStatue then
		self.isUnLock = radiantDecreeCtrl:isUnLockStatue()
		local effectInfo = radiantDecreeRead.getMaxEffectInfo(isStatue)
		if self.isUnLock then
			self.fields.title:setTimeLast(function(timeStr, time)
				_ENV = nil
				_ENV = nil
				;(nil).LV = effectInfo.BraveLv
				;(nil).lv = i18n("gemEnchant_text_39", nil)
				_ENV, _ENV, (nil).time = "gemEnchant_text_39", i18n("gemEnchant_text_39", nil), timeStr
				_ENV, i18n("gemEnchant_text_39", nil).time, ("gemEnchant_text_39").color = "gemEnchant_text_39", "gemEnchant_text_39", self.colorTime
				i18n("gemEnchant_text_39", nil).__default, ("gemEnchant_text_39").color = "gemEnchant_text_39", self.defaultColor
				_ENV = nil
				;(nil).param = "#btn_detail.png"
				;(nil).width = 37
				;(nil).height = 37
				;(nil).custom = "Sprite"
				;(nil).name = "detail"
				;(nil).offsety = 10
				return i18n_html("GloriousDecree_34", nil, (i18n("gemEnchant_text_39", nil))) .. SoraDWrapReplaceTag(nil)
			end)
		else
			self.fields.title:setTimeLast(function(timeStr, time)
				_ENV = nil
				_ENV = nil
				;(nil).LV = effectInfo.BraveLv
				;(nil).lv = i18n("gemEnchant_text_39", nil)
				_ENV, _ENV, (nil).time = "gemEnchant_text_39", i18n("gemEnchant_text_39", nil), timeStr
				_ENV, i18n("gemEnchant_text_39", nil).time, ("gemEnchant_text_39").color = "gemEnchant_text_39", "gemEnchant_text_39", self.colorTime
				i18n("gemEnchant_text_39", nil).__default, ("gemEnchant_text_39").color = "gemEnchant_text_39", self.defaultColor
				_ENV = nil
				;(nil).param = "#btn_detail.png"
				;(nil).width = 37
				;(nil).height = 37
				;(nil).custom = "Sprite"
				;(nil).name = "detail"
				;(nil).offsety = 10
				return i18n_html("GloriousDecree_34", nil, (i18n("gemEnchant_text_39", nil))) .. SoraDWrapReplaceTag(nil)
			end)
		end
	else
		self.isUnLock = radiantDecreeCtrl:isUnLock()
		local effectInfo = radiantDecreeRead.getMaxEffectInfo(isStatue)
		if self.isUnLock then
			if not radiantDecreeCtrl:isLvEnough() then
				local limitLv = radiantDecreeRead.getBuffLimitLv(radiantDecreeCtrl:getLevelIndex())
				radiantDecreeCtrl = radiantDecreeCtrl:getLevelIndex()
				radiantDecreeCtrl:getLevelIndex().lv = limitLv
				self.fields.title:setString(i18n("GloriousDecree_33", radiantDecreeCtrl:getLevelIndex()))
				return
			else
				self.fields.title:setTimeLast(function(timeStr, time)
					_ENV = nil
					;(nil).lv = effectInfo.CastleLv
					_ENV, _ENV, (nil).time = nil, effectInfo.CastleLv, timeStr
					_ENV, effectInfo.CastleLv.time, (nil).color = nil, nil, self.colorTime
					effectInfo.CastleLv.__default, (nil).color = nil, self.defaultColor
					_ENV = nil
					;(nil).param = "#btn_detail.png"
					;(nil).width = 37
					;(nil).height = 37
					;(nil).custom = "Sprite"
					;(nil).name = "detail"
					;(nil).offsety = 10
					return i18n_html("GloriousDecree_35", nil, effectInfo.CastleLv) .. SoraDWrapReplaceTag(nil)
				end)
			end
		else
			self.fields.title:setTimeLast(function(timeStr, time)
				_ENV = nil
				_ENV = nil
				;(nil).LV = effectInfo.CastleLv
				;(nil).lv = i18n("gemEnchant_text_39", nil)
				_ENV, _ENV, (nil).time = "gemEnchant_text_39", i18n("gemEnchant_text_39", nil), timeStr
				_ENV, i18n("gemEnchant_text_39", nil).time, ("gemEnchant_text_39").color = "gemEnchant_text_39", "gemEnchant_text_39", self.colorTime
				i18n("gemEnchant_text_39", nil).__default, ("gemEnchant_text_39").color = "gemEnchant_text_39", self.defaultColor
				_ENV = nil
				;(nil).param = "#btn_detail.png"
				;(nil).width = 37
				;(nil).height = 37
				;(nil).custom = "Sprite"
				;(nil).name = "detail"
				;(nil).offsety = 10
				return i18n_html("GloriousDecree_16", nil, (i18n("gemEnchant_text_39", nil))) .. SoraDWrapReplaceTag(nil)
			end)
		end
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY)
	local leftTime = eventTime.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.fields.title:beginTime(leftTime)
	end
	if self.fields.title:getSize().width >= 500 then
		self.fields.title:setAutoSize(fgui.AutoSizeType.HEIGHT)
		self.fields.title:setSize(cc.size(500, 29))
	end
end
function Com_decreeTimeTip:setColorinfo(colorTime, defaultColor)
	self.colorTime = colorTime
	self.defaultColor = defaultColor
end
function Com_decreeTimeTip:setEndHandle(handler)
	self.fields.title:setTimeEndListener(handler)
end
function Com_decreeTimeTip:onClickText(eventContext)
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_23"), SoraDPlaySound
	uiManager:show("RadiantDecreeBuffPreview", param):setOwnerKey(self)
end
function Com_decreeTimeTip:onShow()
end
return Com_decreeTimeTip
