local baseComponent = require("fgui.base.baseComponent")
local Com_colleges = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_colleges", Com_colleges)
function Com_colleges:onInit()
	self.tableBtn, _UPVALUE0_ = nil, nil
end
function Com_colleges:onShow()
end
function Com_colleges:initData(collegeKeys)
	self.collegeKeys = collegeKeys
	local _total = #self.collegeKeys
	local _angle = 360 / _total
	local _r = 240
	for i, v in ipairs(self.collegeKeys) do
		if not self.tableBtn[v] then
			self.tableBtn[v] = fgui.UIPackage:createObjectFromURL("ui://CollegeView/collegeMainSingle")
			self:addChild(self.tableBtn[v])
		end
		local _rad = math.rad(180 - _angle * i + _angle * 3 / 2)
		self.tableBtn[v]:initData(v)
		self.tableBtn[v]:setPosition(SoraDFPosX(95 - (_r * math.sin(_rad) + 50), 95), _r * math.cos(_rad) + 50)
	end
end
function Com_colleges:gameGuide_getTarget(collegeType)
	return self.tableBtn[collegeType]
end
return Com_colleges
