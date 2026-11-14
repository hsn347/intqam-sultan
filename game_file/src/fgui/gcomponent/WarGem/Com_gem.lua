local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local mainUIDef = include("mainUIDef")
local baseComponent = require("fgui.base.baseComponent")
local Com_gem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/Com_gem60", Com_gem)
function Com_gem:onInit()
	local item = self:getChild("item")
	self.item = item
	self.fields = fguiHelper.get_fields(item)
	self.controllers = fguiHelper.get_controllers(item)
	self.transitions = fguiHelper.get_transitions(item)
end
function Com_gem:onShow()
end
function Com_gem:initData(gemInfo)
	self:setID(gemInfo.id, gemInfo.count)
end
function Com_gem:setID(id, count, needCount)
	self.id = id
	local icon = wargemResRead.getIcon(id)
	local quality = wargemResRead.getBg(id)
	self.fields.Icon_quality:setURL(quality)
	self.fields.Icon:setURL(icon)
	local lv = wargemResRead.getLevel(id)
	self.fields.Text_lv:setString("LV." .. lv)
	if not needCount then
		self.controllers.c1:setSelectedIndex(count and 0 < count and 0 or 1)
		if count and 0 < count then
			self.fields.Text_num:setString(count)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c2:setSelectedIndex(needCount <= count and 0 or 1)
		self.fields.Text_num:setString(count .. "/" .. needCount)
	end
end
function Com_gem:setGroupOn(groupID, isShowNode)
	groupID = groupID or mainUIDef.uiGroupID.group_award_item
	isShowNode = isShowNode or false
	if self.isGroupOn and groupID == self.groupID and not isShowNode == not self.isShowNode then
		return
	end
	self.isGroupOn = true
	self.groupID = groupID
	self.isShowNode = isShowNode
	self.fields.Bg:setGroupID(groupID + 1, isShowNode)
	self.fields.Bg1:setGroupID(groupID + 2, isShowNode)
	self.fields.Icon_quality:setGroupID(groupID + 3, isShowNode)
	self.fields.Icon:setGroupID(groupID + 4, isShowNode)
	self.fields.Bg_lv:setGroupID(groupID + 5, isShowNode)
	self.fields.Bg_num:setGroupID(groupID + 5, isShowNode)
	self.fields.Text_lv:setGroupID(groupID + 6, isShowNode)
	self.fields.Text_lv:setGroupAuto(true)
	self.fields.Text_num:setGroupID(groupID + 7, isShowNode)
	self.fields.Text_num:setGroupAuto(true)
end
return Com_gem
