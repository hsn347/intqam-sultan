local baseComponent = require("fgui.base.baseComponent")
local jumpDesRead = include("jumpDesRead")
local Com_getWay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceDinner/Com_getWay", Com_getWay)
function Com_getWay:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btn_go:setTitle(i18n("common_text_477"))
	self.fields.btn_go:addTouchEventListener(handler(self, self.onClick_btn_template))
end
function Com_getWay:onShow()
end
function Com_getWay:initData(data)
	local sourceId = data
	self.sourceId = data
	local itemCfg = jumpDesRead.getCfg(sourceId)
	if itemCfg then
		if sourceId == 14 then
			self.fields.title:setString(i18n("dress_text_200"))
		else
			self.fields.title:setString(i18n(itemCfg.des))
		end
		if sourceId == 147 then
			scale = 0.8
		end
		self.fields.icon:setURL(itemCfg.icon)
	end
end
function Com_getWay:onClick_btn_template()
	SoraDPlaySound()
	if SoraDJumpBySourceId(self.sourceId) then
		uiManager:close("AllianceDinnerGetWay")
	end
end
return Com_getWay
