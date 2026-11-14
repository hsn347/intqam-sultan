local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateKingdomGroupSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateKingdomGroupSingle", kohMigrateKingdomGroupSingle)
function kohMigrateKingdomGroupSingle:onInit()
	self.isLaunched = false
	self.baseHeight = self:getHeight()
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noInvite:setVisible(false)
	if not SoraDFIsRA() then
		_UPVALUE3_ = self.fields.Text_noInvite
		self.fields.Text_noInvite[1] = self.fields.Text_title
		self.fields.Text_noInvite[2] = self.fields.Text_member
		self.fields.Text_noInvite[3] = self.fields.Sprite_arr
		for __, v in pairs(self.fields.Text_noInvite) do
			v:fixPos()
		end
		self.fields.Sprite_arr:fix()
	end
end
function kohMigrateKingdomGroupSingle:onShow()
end
function kohMigrateKingdomGroupSingle:onItemRenderer(index, obj)
	local kid = self.kingdomList[index + 1]
	_UPVALUE0_ = nil
	;(nil).isPrivilege = self.isPrivilege
	obj:initData(kid, nil)
end
function kohMigrateKingdomGroupSingle:initData(data, index)
	dump(data, "==kohMigrateKingdomGroupSingle:initData==")
	self.data = data
	if not data.kingdomList then
		_ENV = data.kingdomList
	end
	self.kingdomList = data.kingdomList
	local kidMin = self.kingdomList[1]
	local kidMax = self.kingdomList[#self.kingdomList]
	self.isPrivilege = data.type == 0
	self.isApply = data.type == 3
	self.showRedPoint = data.showRedPoint
	if self.isPrivilege then
		self.fields.Text_title:setString(i18n("migrant_move_text27"))
		self.fields.Image_bg:setURL("frame_common_biaotidi05.png")
		self.fields.Text_noInvite:setString(i18n("across_move_noInvitation_desc"))
	elseif self.isApply then
		self.fields.Text_title:setString(i18n("migrant_move_text28"))
		self.fields.Image_bg:setURL("frame_common_biaotidi05.png")
		self.fields.List:setDefaultItem("ui://kohMigrate/kohMigrateApplySingle")
		self.fields.Text_noInvite:setString(i18n("migrant_move_text29"))
	else
		_ENV = i18n("migrant_move_text29")
		i18n("migrant_move_text29").var1 = kidMin
		i18n("migrant_move_text29").var2 = kidMax
		self.fields.Text_title:setString(i18n("across_kingdomListNum_name", i18n("migrant_move_text29")))
		self.fields.Image_bg:setURL("frame_common_biaotidi03.png")
	end
	local member = #self.kingdomList
	if member <= 0 then
		_ENV = i18n("across_kingdomListNum_name", i18n("migrant_move_text29"))
		i18n("across_kingdomListNum_name", i18n("migrant_move_text29")).color = "#BE2828"
		if SoraDWrapHtmlTagByStyle(member, i18n("across_kingdomListNum_name", i18n("migrant_move_text29"))) then
			goto lbl_114
		end
	end
	::lbl_114::
	local memberStr = string.format("(%s)", (tostring(member)))
	self.fields.Text_member:setString(memberStr)
	self:refreshRedPoint()
	self.index = index
	local isLaunched = kohMigrateCtrl:getKingdomListState(self.index)
	self:setState(isLaunched)
end
function kohMigrateKingdomGroupSingle:refreshRedPoint(...)
	self:setReddot(self.showRedPoint)
end
function kohMigrateKingdomGroupSingle:btnClickCallBack()
	SoraDPlaySound()
	self:setState(not self.isLaunched)
	kohMigrateCtrl:setKingdomListState(self.index, self.isLaunched)
end
function kohMigrateKingdomGroupSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeMember()
		self.fields.Sprite_arr:setRotation(SoraDFPosX(90, 0))
	else
		self:createMember()
		self.fields.Sprite_arr:setRotation(0)
	end
	self.isLaunched = state
	if self.isLaunched then
		self.showRedPoint = false
		self:refreshRedPoint()
	end
end
function kohMigrateKingdomGroupSingle:createMember(...)
	if #self.kingdomList <= 0 then
		self.fields.Text_noInvite:setVisible(true)
		self:setHeight(self.baseHeight + 60)
	else
		self.fields.Text_noInvite:setVisible(false)
	end
	self.fields.List:setNumItems(#self.kingdomList)
	self.fields.List:resizeToFit(#self.kingdomList)
end
function kohMigrateKingdomGroupSingle:removeMember(...)
	self.fields.List:setNumItems(0)
	self.fields.List:resizeToFit(0)
	self.fields.Text_noInvite:setVisible(false)
	self:setHeight(self.baseHeight)
end
return kohMigrateKingdomGroupSingle
