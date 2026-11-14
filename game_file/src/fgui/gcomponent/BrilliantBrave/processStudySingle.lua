local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local processStudySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/processStudySingle", processStudySingle)
function processStudySingle:onInit()
	self:fixChildrenPos()
end
function processStudySingle:onShow()
end
function processStudySingle:initData(data, needQuality)
	for i = 1, 3 do
		if data[i] then
			self.fields["single" .. i]:setVisible(true)
			self.fields["single" .. i]:initData(data[i], needQuality)
		else
			self.fields["single" .. i]:setVisible(false)
		end
	end
end
return processStudySingle
