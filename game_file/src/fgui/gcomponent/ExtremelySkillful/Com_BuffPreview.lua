local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuffPreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_BuffPreview", Com_BuffPreview)
function Com_BuffPreview:onInit()
	self:fixChildrenPos()
	self.buffItemList, _ENV, self.lineList, _ENV = self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos
	self.fields.Text_1:setString(i18n("common_text_4488"))
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	table.insert(self.lineList, self.fields.line)
	table.insert(self.buffItemList, self.fields.Buff_Item)
end
function Com_BuffPreview:onShow()
end
function Com_BuffPreview:initData(tag)
	self.tag = tag
	self.buffList = extremelySkillfulRead.getBuffList(self.tag, ExtremelySkillfulCtrl:getGroupIndex())
	local effectInfo = self.buffList[#self.buffList]
	local offsetX = 550 / (#effectInfo.PrivilegeEffect + 1)
	for index, value in ipairs(effectInfo.PrivilegeEffect) do
		local line = self.lineList[index]
		local buff_Item = self.buffItemList[index]
		if not line then
			line = self.fields.line:clone()
			line:addTo(self)
			buff_Item = fgui.UIPackage:createObjectFromURL("ui://ExtremelySkillful/Com_icon")
			buff_Item:addTo(self)
			buff_Item:setPivot(0.5, 0.5, true)
			table.insert(self.lineList, line)
			table.insert(self.buffItemList, buff_Item)
		end
		line:setSize(cc.size(2, 412))
		line:setPosition(cc.p(offsetX * index, 0))
		buff_Item:initData(effectInfo.EffectIcon[index] .. ".png", value)
		buff_Item:setPosition(cc.p(SoraDFPosX(550 - offsetX / 2 - index * offsetX, 550), 42))
	end
	self.fields.Text_1:setSize(cc.size(offsetX, 63))
	self.fields.Text_1:setPosition(cc.p(SoraDFPosX(550 - offsetX / 2, 550), 42))
	if effectInfo.CastleLv[1] == 1 then
		self.fields.Text_1:setString(i18n("common_text_4488"))
	else
		self.fields.Text_1:setString(i18n("build_thriving_8"))
	end
	self.fields.Scroll_Buff:setNumItems(#self.buffList)
end
function Com_BuffPreview:onItemRenderer(index, target)
	target:initData(self.buffList[index + 1].CastleLv, index, self.tag)
end
return Com_BuffPreview
