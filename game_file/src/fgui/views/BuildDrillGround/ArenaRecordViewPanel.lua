local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaRecordViewPanel = class("ArenaRecordViewPanel", baseFguiPanel)
function ArenaRecordViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaRecordViewPanel:ctor", self.viewName)
end
function ArenaRecordViewPanel:onInit()
	print("=======ArenaRecordViewPanel:onInit")
	self.fields.Com_title:initData(i18n("arena_title_02"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noRecord:setString(i18n("common_text_1464"))
end
function ArenaRecordViewPanel:onShow()
	print("=======ArenaRecordViewPanel:onShow")
	self:req4info(self.param.battleType)
end
function ArenaRecordViewPanel:detailBack(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and redata.detailReport then
		local oriData = arenaltCtrl.reportReMake(redata.detailReport, self.battleType)
		dump(oriData, "redata.detailReport", 5)
		local panel = SoraDCreatePanel("mailItemDetailView")
		panel:show()
		panel:hideRightAndLeftBtn()
		panel:initWithData(oriData, "key")
	end
end
function ArenaRecordViewPanel:req4info(battleType)
	SoraDShowLoading(self:displayObject())
	self.battleType = battleType
	arenaCtrl:req4battleReport(self.battleType)
end
function ArenaRecordViewPanel:initData(target, redata)
	SoraDCloseLoading(self:displayObject())
	self.recordList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	if redata and redata.recordList then
		if not redata.recordList then
			_ENV = redata.recordList
		end
		self.recordList = redata.recordList
	end
	local _ENV, dateMap = redata.recordList, redata.recordList
	local _ENV, ret = self:displayObject()
	for i, info in ipairs(self.recordList) do
		local time = info.time
		local y = os.date("!%Y", time)
		local m = os.date("!%m", time)
		local key = y * 100 + m
		if not dateMap[key] then
			dateMap[key] = true
			_ENV = self:displayObject()
			self:displayObject().isTitle = true
			_ENV = self:displayObject()
			self:displayObject().month = i18n(string.format("month_num_%d", m))
			self:displayObject().title = i18n("arena_text_44", self:displayObject())
			table.insert(ret, self:displayObject())
		end
		table.insert(ret, info)
	end
	self.recordList = ret
	self:initView()
end
function ArenaRecordViewPanel:initView()
	self:prepareData()
end
function ArenaRecordViewPanel:prepareData(args)
	self.fields.List:setNumItems(#self.recordList)
	self.fields.List:jumpToTop()
	if next(self.recordList) then
		self.fields.Text_noRecord:setVisible(false)
	else
		self.fields.Text_noRecord:setVisible(true)
	end
	arenaCtrl:clickRecordTip(self.battleType)
end
function ArenaRecordViewPanel:onItemRenderer(index, obj)
	local data = self.recordList[index + 1]
	local c_type = obj:getController("c_type")
	c_type:setSelectedIndex(data.isTitle and 1 or 0)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
	end
	local _fields = obj._fields
	if data.isTitle then
		self:initItemTitle(_fields.Com_recordTitle, data)
	else
		self:initItemSingle(_fields.Com_recordSingle, data)
	end
end
function ArenaRecordViewPanel:initItemTitle(obj, data)
	obj:setString(data.title)
end
function ArenaRecordViewPanel:initItemSingle(obj, data)
	obj.data = data
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Button_replay:addClickListener(function(...)
			SoraDPlaySound()
			SoraDShowLoading(self:displayObject())
			arenaCtrl:req4detailReport(self.battleType, obj.data.index)
		end)
	end
	local c1 = obj:getController("c1")
	if data.bWin then
		c1:setSelectedIndex(0)
		_fields.Text_result:setString("WIN")
	else
		c1:setSelectedIndex(1)
		_fields.Text_result:setString("LOSE")
	end
	local deta = data.newRank - data.oldRank
	if 0 < deta then
		_fields.Text_rank:setString(math.abs(deta))
		_fields.Image_arrow:setVisible(true)
	elseif deta < 0 then
		_fields.Text_rank:setString(math.abs(deta))
		_fields.Image_arrow:setVisible(true)
	else
		_fields.Text_rank:setString("")
		_fields.Image_arrow:setVisible(false)
	end
	local _ENV, showLord = _fields.Image_arrow.setVisible, _fields.Image_arrow.setVisible
	if data.bAtker then
		showLord = data.defInfo
		_fields.Sprite_result:setURL("icon_alliancewar_attacker.png")
	else
		showLord = data.atkInfo
		_fields.Sprite_result:setURL("icon_alliancewar_defender.png")
	end
	local showName = arenaltCtrl.specialCreateName(showLord, self.battleType ~= gArenaBattleType.ARENA_LOCAL)
	_fields.Text_lord:setString(showName)
	_fields.Text_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.time))
	_fields.Com_head:setHeadSprite(showLord.iconID, showLord.avatar)
end
return ArenaRecordViewPanel
