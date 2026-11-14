local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaRankViewPanel = class("ArenaRankViewPanel", baseFguiPanel)
function ArenaRankViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaRankViewPanel:ctor", self.viewName)
end
function ArenaRankViewPanel:onInit()
	print("=======ArenaRankViewPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_rank:setString(i18n("common_text_2193"))
	_fields.Text_name:setString(i18n("common_text_3155"))
	_fields.Text_des:setString(i18n("arena_text_36"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function ArenaRankViewPanel:onShow()
	print("=======ArenaRankViewPanel:onShow")
	local param = self.param
	self:req4info(param.battleType, param.blockID, param.lordInfo)
end
function ArenaRankViewPanel:reqBackInfo(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and next(redata) and redata.fromPanel == "ArenaRankView" then
		_ENV = self:displayObject()
		self:displayObject().lordInfo = redata.lordInfo
		self:displayObject().armyBuff, _ENV, self:displayObject().armyList = redata.armyInfo, redata.armyInfo, redata.armyInfo
		self:displayObject().battleType = self.battleType
		uiManager:show("ArenaArmyInfoView", self:displayObject())
	end
end
function ArenaRankViewPanel:req4info(battleType, blockID, lordInfo)
	SoraDShowLoading(self:displayObject())
	arenaCtrl:req4battleRanks(battleType, blockID)
	self.myInfo = lordInfo
	local index = arenaltCtrl.getSubSectionIndex(battleType, blockID)
	local blockInfo = arenaltCtrl.getSubSectionList(index)
	if battleType == gArenaBattleType.ARENA_LOCAL then
		_ENV = self:displayObject()
		self:displayObject().group = i18n(blockInfo.name)
		self.fields.Com_title:updateTitle(i18n("arena_title_03", self:displayObject()))
	elseif battleType == gArenaBattleType.AREAN_GLOBAL then
		_ENV = i18n("arena_title_03", self:displayObject())
		i18n("arena_title_03", self:displayObject()).group = i18n(blockInfo.name)
		self.fields.Com_title:updateTitle(i18n("arena_title_04", i18n("arena_title_03", self:displayObject())))
	end
end
function ArenaRankViewPanel:initData(target, redata)
	SoraDCloseLoading(self:displayObject())
	self.rankList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	if redata then
		self.blockID = redata.groupID
		self.battleType = redata.battleType
		if not redata.rankList then
			_ENV = redata.rankList
		end
		self.rankList = redata.rankList
	end
	self:initView()
end
function ArenaRankViewPanel:initView()
	if self.myInfo and next(self.myInfo) and self.myInfo.myRank > 0 then
		self.controllers.c1:setSelectedIndex(1)
		self:refreshSingle(self.fields.Com_self, self.myInfo, self.myInfo.myRank, true)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self:prepareData()
end
function ArenaRankViewPanel:prepareData()
	self.fields.List:setNumItems(#self.rankList)
end
function ArenaRankViewPanel:onItemRenderer(index, obj)
	local data = self.rankList[index + 1]
	self:refreshSingle(obj, data, data.rank)
end
function ArenaRankViewPanel:refreshSingle(obj, data, rank, isSelf)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
		if not SoraDFIsRA() then
			local _fields = obj._fields
			_fields.selfBg:fix()
			_fields.bg1:fix()
			_fields.bg2:fix()
			_fields.bg3:fix()
		end
	end
	local _fields = obj._fields
	_fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	_fields.Com_head:setHandle(function()
		SoraDShowLoading(self:displayObject())
		arenaCtrl:req4rankArmyInfo(self.battleType, self.blockID, rank, data, "ArenaRankView")
	end)
	local needKid = true
	if isSelf then
		needKid = self.battleType ~= gArenaBattleType.ARENA_LOCAL
	end
	local showName = arenaltCtrl.specialCreateName(data, needKid)
	_fields.Text_name:setString(showName)
	_fields.Text_force:setString(string.formatnumberthousands(data.fightCapacity))
	local c1 = obj:getController("c1")
	local c_top3 = obj:getController("c_top3")
	if 3 < rank then
		_fields.Text_index:setString(rank)
		c1:setSelectedIndex(0)
		c_top3:setSelectedIndex(0)
	elseif rank <= 3 and 0 < rank then
		c1:setSelectedIndex(rank)
		c_top3:setSelectedIndex(rank)
	end
	if self.myInfo and self.myInfo.myRank and rank == self.myInfo.myRank then
		c1:setSelectedIndex(4)
	end
	if isSelf then
		_fields.Load_jump:addClickListener(handler(self, self.btnJumpClick))
	end
end
function ArenaRankViewPanel:btnJumpClick()
	SoraDPlaySound()
	for i, data in ipairs(self.rankList) do
		if data.rank == self.myInfo.myRank then
			self.fields.List:scrollToView(i - 1)
			break
		end
	end
end
return ArenaRankViewPanel
