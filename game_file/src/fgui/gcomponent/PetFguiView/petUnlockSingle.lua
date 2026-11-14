local baseComponent = require("fgui.base.baseComponent")
local petUnlockSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/petUnlockSingle", petUnlockSingle)
function petUnlockSingle:onInit()
	self.fields.Button_jump:addClickListener(handler(self, self.btnJumpCallBack))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function petUnlockSingle:onShow()
end
function petUnlockSingle:initData(data)
	self.tableData = data
	self.fields.Button_jump:setVisible(false)
	if self.tableData.curCastlelv then
		self:needUpgrade()
	elseif self.tableData.curDebrisCount then
		self:needTools()
	elseif self.tableData.curKillCount then
		self:needKill()
	elseif self.tableData.curLordlv then
		self:needLordLv()
	end
	if self.tableData.isreach then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function petUnlockSingle:needUpgrade()
	local buildLogic = include("buildLogic")
	local buildRead = include("buildDescribeRead")
	self.fields.Button_jump:setString(i18n("common_text_382"))
	self.fields.Image_icon:setURL(buildRead.getIcon(BUILDID.CASTLE))
	local warLv = buildLogic.transformBuildLvToWarLv(self.tableData.needCastlelv)
	local buildName = buildRead.getName(BUILDID.CASTLE)
	if 0 < warLv then
		_ENV = buildRead.getIcon(BUILDID.CASTLE)
		buildRead.getIcon(BUILDID.CASTLE).build = buildName
		buildRead.getIcon(BUILDID.CASTLE).lv = warLv
		self.fields.Text_des:setString(i18n("common_text_1957", buildRead.getIcon(BUILDID.CASTLE)))
	else
		_ENV = i18n("common_text_1957", buildRead.getIcon(BUILDID.CASTLE))
		i18n("common_text_1957", buildRead.getIcon(BUILDID.CASTLE)).name = buildName
		i18n("common_text_1957", buildRead.getIcon(BUILDID.CASTLE)).lv = self.tableData.needCastlelv
		self.fields.Text_des:setString(i18n("common_text_334", i18n("common_text_1957", buildRead.getIcon(BUILDID.CASTLE))))
	end
end
function petUnlockSingle:needLordLv()
	self.fields.Image_icon:setURL("quest_type_lord.png")
	_ENV = nil
	;(nil).name = i18n("common_text_1536")
	;(nil).lv = self.tableData.needLoardLv
	self.fields.Text_des:setString(i18n("common_text_334", nil))
end
function petUnlockSingle:needKill()
	self.fields.Image_icon:setURL("icon_lord_kill.png")
	self.fields.Text_des:setString(i18n("common_text_824") .. "   " .. string.formatnumberthousands(self.tableData.curKillCount) .. "/" .. string.formatnumberthousands(self.tableData.needKillCount))
end
function petUnlockSingle:needTools()
	local itemDesRead = include("itemDesRead")
	self.fields.Button_jump:setVisible(not self.tableData.isreach)
	self.fields.Button_jump:setString(i18n("common_text_337"))
	self.fields.Image_icon:setURL(itemDesRead.getIcon(self.tableData.debrisid))
	self.fields.Text_des:setString(itemDesRead.getName(self.tableData.debrisid) .. "   " .. tostring(self.tableData.curDebrisCount) .. "/" .. self.tableData.needDebriscount)
end
function petUnlockSingle:btnJumpCallBack()
	SoraDPlaySound()
	if self.tableData.curDebrisCount then
		print("宠物碎片不足---")
		_ENV = "宠物碎片不足---"
		;("宠物碎片不足---").msg = "MESSAGE_PET_ITEM_GUILD"
		;("宠物碎片不足---").itemID = self.tableData.debrisid
		SoraDSendMessage("宠物碎片不足---")
	end
end
return petUnlockSingle
