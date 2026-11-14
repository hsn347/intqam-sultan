local castleChangeAttrNode = include("castleChangeAttrNode")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Item_Name:fixPos()
	self.fields.Item_Value:fixPos()
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.data = data
	self.fields.Item_Bg:setVisible(self.data.isShowBg or false)
	if self.data.nodeType == castleChangeAttrNode.NodeType.title then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.txt_title:setString(self.data.title)
	elseif self.data.nodeType == castleChangeAttrNode.NodeType.attr then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Item_Name:setString(attrltCtrl.getAttrDes(self.data.attrID) .. ":")
		local strValue = propParser.getFormatByAttrIDAndValue(self.data.attrID, self.data.attrValue)
		self.fields.Item_Value:setString(strValue)
		self.fields.Item_Name:setColor(self.data.isActive and cc.c3b(240, 230, 210) or cc.c3b(120, 120, 120))
		self.fields.Item_Value:setColor(self.data.isActive and cc.c3b(0, 190, 30) or cc.c3b(120, 120, 120))
	elseif self.data.nodeType == castleChangeAttrNode.NodeType.none then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.txt_title:setString(i18n("skin_text_04"))
	end
end
return Com_list
