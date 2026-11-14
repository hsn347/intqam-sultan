local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Com_rankInfo", Com_rankInfo)
function Com_rankInfo:onInit()
	self.editData, _ENV, self.tableRankData, _ENV = nil, nil, nil, nil
	self.isEdited = false
	self.fields.Text_des:setString(i18n("common_text_223"))
	self.fields.Button_change:setString(i18n("common_text_244"))
	self.fields.Button_change:addClickListener(handler(self, self.btnChangeClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_rankInfo:onShow()
end
function Com_rankInfo:onItemRenderer(index, obj)
	obj:initData(self.tableRankData[#self.tableRankData - index], index + 1, self.isEdited)
end
function Com_rankInfo:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_PERMISSION_SET", handler(self, self.editUpdate))
end
function Com_rankInfo:editUpdate(target, data)
	if not self.editData[data.key] then
		self.editData[data.key], _ENV = nil, nil
	end
	self.editData[data.key][data.rank] = data.status
	for k, v in ipairs(self.tableRankData) do
		if v.key == data.key then
			v.data[data.rank].status = data.status
		end
	end
	self.fields.List:setNumItems(#self.tableRankData)
end
function Com_rankInfo:initData()
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local isLeader = ownRank == gAllianceRank.R5
	self.fields.Button_change:setVisible(isLeader)
	self.tableRankData = permissionCtrl:getShowList()
	self.fields.List:setNumItems(#self.tableRankData)
	self.fields.List:resizeToFit(#self.tableRankData)
	self.fields.lineBottom:setPositionY(self.fields.List:getHeight())
	for i = 0, 7 do
		self.fields["Image_line_" .. i]:setWidth(self.fields.List:getHeight())
		if not SoraDFIsRA() then
			self.fields["Image_line_" .. i]:setPositionX(self:getWidth() - self.fields["Image_line_" .. i]:getPositionX() + 2)
		end
	end
	self.fields.Button_change:setPositionY(self.fields.List:getHeight() + 40)
	local btnPosY = self.fields.Button_change:getPositionY()
	self.fields.Text_des:setPositionY(isLeader and btnPosY + 35 or btnPosY - 35)
end
function Com_rankInfo:btnChangeClick()
	SoraDPlaySound()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	self.isEdited = not self.isEdited
	if self.isEdited then
		self.fields.Button_change:setString(i18n("common_text_195"))
		self.fields.List:setNumItems(#self.tableRankData)
	else
		self.fields.Button_change:setString(i18n("common_text_244"))
		self.fields.List:setNumItems(#self.tableRankData)
		permissionCtrl:reqModifyPermission(self.editData)
		SoraDShowMsgTip(i18n("common_text_2370"))
	end
end
function Com_rankInfo:isInEditMode()
	return self.isEdited
end
return Com_rankInfo
