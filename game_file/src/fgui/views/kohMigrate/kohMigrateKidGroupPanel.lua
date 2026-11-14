local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateKidGroupPanel = class("kohMigrateKidGroupPanel", baseFguiPanel)
function kohMigrateKidGroupPanel:ctor(...)
	kohMigrateKidGroupPanel.super.ctor(self, ...)
	print("kohMigrateKidGroupPanel:ctor", self.viewName)
	self.debug = true
	self.selfKid = gametop.playertop_:getKingdomID()
end
function kohMigrateKidGroupPanel:onInit()
	print("=======kohMigrateKidGroupPanel:onInit")
	self.fields.Com_title:initData(i18n("arossDesc_text_015"), handler(self, self.onClickClose))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function kohMigrateKidGroupPanel:onShow()
	print("=======kohMigrateKidGroupPanel:onShow")
	kohMigrateCtrl:reqGroupList()
	SoraDShowLoading(self)
end
function kohMigrateKidGroupPanel:initKingdomGroup(groupDatas)
	local _ENV, groupDatas = nil, groupDatas or nil
	local _ENV, ret
	local _ENV, newKidList
	for i, kidList in ipairs(groupDatas) do
		local _ENV, oldKidList
		for __, kid in ipairs(kidList) do
			if kohMigrateRead.checkIsNewkingdom(kid) then
				table.insert(newKidList, kid)
			else
				table.insert(oldKidList, kid)
			end
		end
		_ENV = (for generator)
		ipairs(kidList).groupID = i
		local ipairs(kidList).kidList, data = oldKidList, ipairs(kidList)
		if table.indexof(oldKidList, self.selfKid) then
			self.selfGroup = i
			table.insert(ret, 1, data)
		else
			table.insert(ret, data)
		end
	end
	if 0 < #newKidList then
		local newGroupID = #groupDatas + 1
		_ENV = nil
		;(nil).groupID = newGroupID
		;(nil).kidList = newKidList
		;(nil).isNewKingdom = true
		table.insert(ret, nil)
		if table.indexof(newKidList, self.selfKid) then
			self.selfGroup = newGroupID
		end
	end
	self.dataList = ret
	self.fields.List:setNumItems(#self.dataList)
end
function kohMigrateKidGroupPanel:onItemProvider(index)
	local groupData = self.dataList[index + 1]
	if groupData.isNewKingdom then
		return "ui://kohMigrate/Com_newKidGroup"
	else
		return "ui://kohMigrate/Com_kidGroup"
	end
end
function kohMigrateKidGroupPanel:onItemRenderer(index, obj)
	local groupData = self.dataList[index + 1]
	if groupData.isNewKingdom then
		local _fields = fguiHelper.get_fields(obj)
		self:initComKidGroup(_fields.Com_kidGroup, groupData)
		_fields.Text_des:setString(i18n("migrant_move_text48"))
	else
		self:initComKidGroup(obj, groupData)
	end
end
function kohMigrateKidGroupPanel:initComKidGroup(obj, groupData)
	local groupID = groupData.groupID
	local kidList = groupData.kidList
	local _fields = fguiHelper.get_fields(obj)
	if groupData.isNewKingdom then
		_fields.Text_title:setString(i18n("migrant_move_text46"))
	else
		_ENV = i18n("migrant_move_text46")
		i18n("migrant_move_text46").num = groupID
		_fields.Text_title:setString(i18n("migrant_move_text24", i18n("migrant_move_text46")))
	end
	if groupID == self.selfGroup then
		_fields.Image_bg:setGrayed(false)
	else
		_fields.Image_bg:setGrayed(true)
	end
	local kidStr = ""
	local kidMax = #kidList
	for i, v in ipairs(kidList) do
		local _kidStr = tostring(v)
		if v == self.selfKid then
			_ENV = i18n("migrant_move_text24", i18n("migrant_move_text46"))
			i18n("migrant_move_text24", i18n("migrant_move_text46")).color = "#E02B2B"
			_kidStr = SoraDWrapHtmlTagByStyle(_kidStr, i18n("migrant_move_text24", i18n("migrant_move_text46")))
		end
		kidStr = kidStr .. _kidStr
		if i ~= kidMax then
			kidStr = kidStr .. ", "
		end
	end
	_fields.Text_kid:setString(kidStr)
end
return kohMigrateKidGroupPanel
