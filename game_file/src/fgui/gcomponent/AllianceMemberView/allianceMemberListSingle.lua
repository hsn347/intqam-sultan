local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceMemberListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/allianceMemberListSingle", allianceMemberListSingle)
function allianceMemberListSingle:onInit()
	self.aid = nil
	self.rank = nil
	self.ownUid = lordInfoCtrl:getLordInfo().base.uid
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Sprite_arr:fixPos()
	self.fields.Text_title:fixPos()
	self.fields.Text_member:fixPos()
	self.fields.Sprite_icon:fixPos()
end
function allianceMemberListSingle:onShow()
end
function allianceMemberListSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateOtherUI))
end
function allianceMemberListSingle:onListRenderer(index, obj)
	if self.rank <= gAllianceRank.R1 then
		obj:setHeight(155)
	else
		obj:setHeight(210)
	end
	obj:initData(self.rank, self.memberList[index + 1], self.aid)
end
function allianceMemberListSingle:initData(data, index, aid)
	self.data = data
	self.index = index
	self.aid = aid
	self.rank = self.data.rank
	if not self.data.memberList then
		_ENV = self.data.memberList
	end
	self.memberList = self.data.memberList
	self.fields.Sprite_arr:setRotation(self.data.isOpen and 0 or SoraDFIsRA() and 90 or -90)
	local online = 0
	local total = #self.memberList
	for i, v in ipairs(self.memberList) do
		if v:getProperty("online") == 0 and 0 < v.minfo.uid then
			online = online + 1
		end
	end
	_ENV = v.minfo.uid
	v.minfo.uid.member = online
	v.minfo.uid.total = total
	self.fields.Text_member:setString("(" .. i18n("common_text_155", v.minfo.uid) .. ")")
	self.fields.Sprite_icon:setSpriteFrame(allianceDesRead.getIcon(self.rank))
	local singleH = 220
	if self.rank <= gAllianceRank.R1 then
		singleH = 165
	end
	if self.data.isOpen then
		if self.rank == gAllianceRank.R5 then
			self.fields.List:setAlign(1)
		else
			self.fields.List:setAlign(SoraDFIsRA() and 2 or 0)
		end
		if self.rank == gAllianceRank.OFFICIAL then
			for rank = gAllianceOfficial.COMMANDER, gAllianceOfficial.RECRUITER do
				local isSetted = false
				for k, v in ipairs(self.memberList) do
					if v:getProperty("official") == rank then
						isSetted = true
						break
					end
				end
				if not isSetted then
					local member = include("member").new()
					member:setProperty("official", rank)
					table.insert(self.memberList, member)
				end
			end
		end
		self.fields.List:setHeight(math.ceil(#self.memberList / 2) * singleH)
		local _ENV, online = self.fields.List.setHeight, self.fields.List.setHeight
		local _ENV, unonline = self.fields.List, self.fields.List
		for i, v in ipairs(self.memberList) do
			if v:getProperty("uid") == self.ownUid then
				table.insert(online, 1, v)
			elseif v:getProperty("online") == 0 then
				table.insert(online, v)
			else
				table.insert(unonline, v)
			end
		end
		self.memberList, _ENV = ipairs(self.memberList)
		for i, v in ipairs(online) do
			table.insert(self.memberList, v)
		end
		for i, v in ipairs(unonline) do
			table.insert(self.memberList, v)
		end
		self.fields.List:setNumItems(#self.memberList)
	else
		self.fields.List:setHeight(0)
		self.fields.List:setNumItems(0)
	end
	self:setHeight(self.data.isOpen and 56 + math.ceil(#self.memberList / 2) * singleH or 56)
	self:updateOtherUI()
	if self.aid == allianceMgr:getOwnAid() and allianceMgr:hasJoinAlliance() and self.rank > gAllianceRank.R0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO) then
		_ENV = include("member").new()
		include("member").new().member = online
		include("member").new().total = total
		self.fields.Text_member:setString("(" .. i18n("common_text_155", (include("member").new())) .. ")")
	else
		self.fields.Text_member:setString(tostring(total))
	end
end
function allianceMemberListSingle:updateOtherUI()
	self.fields.Sprite_icon:setSpriteFrame(allianceDesRead.getIcon(self.rank))
	local rankKey = "r" .. self.rank .. "Name"
	local rankTitle = allianceMgr:getAllianceProperty(rankKey, self.aid)
	if rankTitle and string.utf8len(rankTitle) == 0 then
		allianceDesRead = self.aid
		self.aid.rank = self.rank
		rankTitle = i18n("common_text_205", self.aid)
		if self.rank == gAllianceRank.OFFICIAL then
			rankTitle = i18n("alliance_office_title_02")
		end
	elseif self.rank == gAllianceRank.OFFICIAL then
		if rankTitle and string.utf8len(rankTitle) > 0 then
		else
			rankTitle = i18n("alliance_office_title_02")
		end
	elseif self.rank == gAllianceRank.R0 then
		rankTitle = i18n("common_text_665")
	end
	self.fields.Text_title:setString(rankTitle)
end
function allianceMemberListSingle:btnClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_UI_MEMBERLIST_OPEN"
	;(nil).isOpen = not self.data.isOpen
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
return allianceMemberListSingle
