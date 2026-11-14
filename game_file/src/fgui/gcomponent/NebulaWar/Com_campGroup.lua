local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local nebulaWarUtil = include("nebulaWarUtil")
local GROUP_ID = nebulaWarUtil.GROUP_ID
local baseComponent = require("fgui.base.baseComponent")
local Com_campGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWar/Com_campGroup", Com_campGroup)
function Com_campGroup:onInit()
	self.selfKid = gametop.playertop_:getKingdomID()
	GROUP_ID = gametop.playertop_
	gametop.playertop_[1] = self.fields.Sprite_bg
	gametop.playertop_[2] = self.fields.Sprite_frame
	for i, v in ipairs(gametop.playertop_) do
		v:setGroupID(GROUP_ID.group_frame)
	end
	self.fields.Sprite_own:fix()
	self.fields.Sprite_win:setGroupID(GROUP_ID.group_win)
	self.fields.Sprite_dark:setGroupID(GROUP_ID.group_dark)
	self.fields.List_kingdom:setItemRenderer(handler(self, self.onKingdomItemRederer))
end
function Com_campGroup:onShow()
	self:setSpriteWinVisible(false)
end
function Com_campGroup:initData(group)
	self.group = group
	self.fields.List_kingdom:setNumItems(#self.group)
	local index = table.indexof(self.group, self.selfKid)
	if index then
		self.controllers.c_own:setSelectedIndex(1)
		self.fields.Sprite_own:setPositionY(self.fields.List_kingdom:getY() + (index - 1) * 30)
		self.fields.Sprite_own:setGroupID(GROUP_ID.group_self)
	else
		self.controllers.c_own:setSelectedIndex(0)
		self.fields.Sprite_own:setGroupID(GROUP_ID.group_frame)
	end
end
function Com_campGroup:onKingdomItemRederer(index, obj)
	local kid = self.group[index + 1]
	if not obj._initGroup then
		obj._initGroup = true
		obj:getChild("title"):setGroupAuto(true)
		obj:fixChildrenPos()
	end
	local ret, kingdom = kingdomCtrl:isFoundKingdomID(kid)
	if not ret then
		obj:setVisible(false)
		return
	end
	obj:setString(string.format("#%0d", kid))
	local flagImage = nationalFlagRead.getImgByID(kingdom.flagid)
	obj:setIcon(flagImage)
	if self.selfKid == kid then
		obj:getChild("icon"):setGroupID(GROUP_ID.group_self)
		obj:getChild("title"):setGroupID(GROUP_ID.group_self)
	else
		obj:getChild("icon"):setGroupID(GROUP_ID.group_icon)
		obj:getChild("title"):setGroupID(GROUP_ID.group_title)
	end
end
function Com_campGroup:setSpriteWinVisible(visible)
	if visible then
		self.controllers.c_win:setSelectedIndex(1)
	else
		self.controllers.c_win:setSelectedIndex(0)
	end
end
function Com_campGroup:setComponentDark(isDark)
	if isDark then
		self.controllers.c_dark:setSelectedIndex(1)
	else
		self.controllers.c_dark:setSelectedIndex(0)
	end
end
return Com_campGroup
