local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildStateNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildStateNode", allianceBuildStateNode)
function allianceBuildStateNode:onInit()
	self.tableSingleData, _ENV = nil, nil
	self.fields.Text_des:setString(i18n("common_text_3007"))
	self.scrollBuild = self.fields.ScrollView_build
	self.scrollBuild:setScrollEnable(false)
	self.scrollBuild:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceBuildStateNode:onShow()
end
function allianceBuildStateNode:initData(data)
	self.tableSingleData = data
	self:initScroll()
end
function allianceBuildStateNode:initScroll()
	self.scrollBuild:setNumItems(#self.tableSingleData)
	local innerH = self.scrollBuild:getInnerContainerSize().height
	local scrollH = self.scrollBuild:getContentSize().height
	self.scrollBuild:setScrollEnable(innerH > scrollH)
end
function allianceBuildStateNode:onItemRenderer(index, obj)
	local data = self.tableSingleData[index + 1]
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_fields.Text_pos:addClickListener(handler(self, self.btnClickCallBack))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_ENV = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).x = data.pos.x
	handler(self, self.btnClickCallBack).y = data.pos.y
	_ENV = "common_text_2155"
	;("common_text_2155").u = true
	_fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_2155", handler(self, self.btnClickCallBack)), "common_text_2155"))
	_fields.Text_name:setString(allianceDesRead.getBuildName(data.bid))
	_fields.Text_pro:setString(i18n("common_text_3006"))
	_fields.Text_pos:setTag(index)
end
function allianceBuildStateNode:btnClickCallBack(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local data = self.tableSingleData[index + 1]
	SoraDGotoWorldMapPoint(data.pos, true)
	SoraDRemoveAllPrePanelFromManager(self)
end
function allianceBuildStateNode:setScroll(scroll)
	self.scroll = scroll
end
return allianceBuildStateNode
