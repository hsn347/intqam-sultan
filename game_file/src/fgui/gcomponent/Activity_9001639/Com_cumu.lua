local activity_9001639_Ctrl = SoraDGetCtrl("activity_9001639_Ctrl")
local activity_9001639_Read = include("activity_9001639_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_cumu = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001639/Com_cumu", Com_cumu)
function Com_cumu:onInit()
	self.stageList, _ENV = nil, nil
	self.fields.Text_extra:setString(i18n("eidal_market_text2"))
	self.fields.Btn_cumu:addClickListener(handler(self, self.btnClick))
	self.fields.Bar:setMax(100)
	local cfgList = activity_9001639_Read.getDailyCfg()
	for k, v in ipairs(cfgList) do
		table.insert(self.stageList, v.goldaim)
		if self.fields["Text_p" .. k] then
			self.fields["Text_p" .. k]:setString(v.goldaim)
		end
	end
	self:fixChildrenPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_cumu:onShow()
end
function Com_cumu:initData()
	local val = activity_9001639_Ctrl:getCumulateGold()
	local percent = SoraDGetStageValue(val, self.stageList)
	self.fields.Bar:setValue(percent)
	self.fields.title_score:setString(val)
end
function Com_cumu:btnClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001639_CumuPop")
end
return Com_cumu
