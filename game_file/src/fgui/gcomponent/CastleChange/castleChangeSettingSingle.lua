local baseComponent = require("fgui.base.baseComponent")
local castleChangeSettingSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/castleChangeSettingSingle", castleChangeSettingSingle)
function castleChangeSettingSingle:onInit()
	self.fields.CheckBox_Box:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function castleChangeSettingSingle:onShow()
end
function castleChangeSettingSingle:initData(cfg)
	self.cfg = cfg
	self.fields.Text_Title:setString(cfg.title)
	self.fields.Text_Des:setString(cfg.des)
	self.fields.CheckBox_Box:setSelected(cfg.isShow())
end
function castleChangeSettingSingle:btnClick()
	if self.cfg.handle then
		self.cfg.handle(self.fields.CheckBox_Box:isSelected())
	end
end
return castleChangeSettingSingle
