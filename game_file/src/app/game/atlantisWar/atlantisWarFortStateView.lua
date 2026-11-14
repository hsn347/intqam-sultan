local AMBC = require_data("atlantiswar_map_build_config").data
local atlantisWarBatteryStateView = include("atlantisWarBatteryStateView")
local atlantisWarFortStateView = class("atlantisWarFortStateView", atlantisWarBatteryStateView)
function atlantisWarFortStateView:ctor(...)
	atlantisWarFortStateView.super.ctor(self, ...)
end
function atlantisWarFortStateView:showEffect()
	local effectqfsz = SoraDCreatAnimation("atlantis_qfsz", nil, true)
	effectqfsz:setPosition(cc.p(-20, 415))
	self.Bottom_Node:addChild(effectqfsz)
	local effectqfsz_middle_down = SoraDCreatAnimation("atlantis_qfsz_middle_down", nil, true)
	effectqfsz_middle_down:setPosition(cc.p(0, 500))
	self.Bottom_Node:addChild(effectqfsz_middle_down, -1)
	local effectqfsz_bottom = SoraDCreatAnimation("atlantis_qfsz_bottom", nil, true)
	effectqfsz_bottom:setPosition(cc.p(0, -20))
	self.Bottom_Node:addChild(effectqfsz_bottom)
	local effectqfsz_top = SoraDCreatAnimation("atlantis_qfsz_top", nil, true)
	effectqfsz_top:setPosition(cc.p(335, 70))
	self.frame_shmc_top_01_8:addChild(effectqfsz_top)
end
function atlantisWarFortStateView:initWidget(...)
	atlantisWarFortStateView.super.initWidget(self, ...)
	self.Button_record:setTitleText(i18n("common_text_836"))
	self.Button_record:addTouchEventListener(handler(self, self.btnRecordClick))
end
function atlantisWarFortStateView:showOcuppyInfo(...)
	atlantisWarFortStateView.super.showOcuppyInfo(self, ...)
end
function atlantisWarFortStateView:btnRecordClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("batteryStateViewLogRecord")
		local title_name = AMBC[self.siteClassID].name
		_ENV = nil
		;(nil).place = i18n(title_name)
		;(nil).buildId = self.siteClassID
		;(nil).warType = gKingdomClassType.atlantis
		panel:initData(nil)
		panel:show()
	end
end
function atlantisWarFortStateView:fitView(...)
	if display.height < 900 then
		_ENV = display.height
		display.height[901] = -47
		display.height[902] = -90
		display.height[903] = -100
		local display.height[904], config = -100, display.height
		if config[self.siteClassID] then
			self.Sprite_build:setPositionY(config[self.siteClassID])
		end
		if self.siteClassID ~= 904 then
			self.Sprite_build:setScale(0.8)
		end
	elseif display.height < 1000 then
		if self.siteClassID ~= 904 then
			self.Sprite_build:setScale(0.9)
		end
		self.Sprite_build:setPositionY(-35)
	end
end
return atlantisWarFortStateView
