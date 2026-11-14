local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_divinebeast = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_divinebeast", Com_armyDetail_divinebeast)
local divineBeastRead = include("divineBeastRead")
function Com_armyDetail_divinebeast:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
end
function Com_armyDetail_divinebeast:onShow()
	self.stars, _UPVALUE0_ = nil, nil
	for i = 1, 10 do
		self.stars[i] = self.fields["star" .. i]
	end
end
function Com_armyDetail_divinebeast:initData(divineBeastInfo)
	dump(divineBeastInfo, "Com_armyDetail_divinebeast:initData")
	self.divineID = divineBeastInfo.beastId
	_ENV = nil
	;(nil).num = divineBeastInfo.stepLv or 0
	self.fields.txtStepLv:setString(i18n("Divine_beast_text_37", nil))
	self.fields.txtStapLvDesc:setString(i18n("Divine_beast_text_36"))
	self.fields.speireIcon:setURL(divineBeastRead.getIcon(self.divineID))
	local starLv = divineBeastInfo.starLv or 0
	self.fields.txtStapLv:setString(starLv)
end
return Com_armyDetail_divinebeast
