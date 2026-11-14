local petCtrl = SoraDGetCtrl("petCtrl")
local petDesRead = include("petDesRead")
local mailFunctions = include("mailFunctions")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetLordViewPanel = class("PetLordViewPanel", baseFguiPanel)
function PetLordViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetLordViewPanel:ctor", self.viewName)
end
function PetLordViewPanel:onInit()
	print("=======PetLordViewPanel:onInit")
	self.fields.pet_model = self.fields.pet_cut:getChild("pet_model")
	self.fields.Button_left:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and 1 or -1)
	self.fields.Button_right:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and -1 or 1)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.scroll_page:setItemRenderer(handler(self, self.onPageRenderer))
end
function PetLordViewPanel:onShow()
	print("=======PetLordViewPanel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self:init(self.param)
end
function PetLordViewPanel:init(data)
	self.petMap = clone(petCtrl:getSortPetMapInfoList())
	for i, v in ipairs(self.petMap) do
		if v.pid == 1251 then
			table.remove(self.petMap, i)
			break
		end
	end
	dump(self.petMap, "self.petMap", 10)
	self.curIndex = 1
	for i, v in ipairs(self.petMap) do
		if v.pid == data.pid then
			self.curIndex = i
		end
	end
	self:petSelect(self.curIndex)
	self.fields.Button_left:setVisible(#self.petMap > 1)
	self.fields.Button_right:setVisible(#self.petMap > 1)
end
function PetLordViewPanel:onPageBtnClick(sender, params)
	local nextIdx = self.curIndex + params
	if nextIdx > #self.petMap then
		nextIdx = 1
	elseif nextIdx <= 0 then
		nextIdx = #self.petMap
	end
	self.curIndex = nextIdx
	self:petSelect(self.curIndex)
end
function PetLordViewPanel:onPageRenderer(index, obj)
	local isSelect = index + 1 == self.curIndex
	if isSelect then
		obj:setIcon("frame_lace_09_01.png")
	else
		obj:setIcon("frame_lace_09_02.png")
	end
end
function PetLordViewPanel:petSelect(index)
	self.curPet = self.petMap[index]
	self.curRank = #self.curPet.rankInfo
	petDesRead = nil
	;(nil).pid = self.curPet.pid
	;(nil).rank = self.curRank
	self.fields.pet_model:initData(nil)
	self.fields.pet_model:setScale(0.8)
	local petName = petDesRead.getName(self.curPet.pid)
	self.fields.Panel_bg:setString(petName)
	local unlockdata = petCtrl:getPetUnlockDataById(self.curPet.pid)
	local feederdata = petCtrl:getPetFeederById(self.curPet.pid)
	dump(unlockdata, "unlockdata", 10)
	dump(feederdata, "feederdata", 10)
	petDesRead, petDesRead = feederdata, dump
	feederdata.data = unlockdata
	petDesRead = nil
	;(nil).name = petName
	petDesRead, dump[1], feederdata.title = feederdata, feederdata, i18n("pet_text_03", nil)
	feederdata.data = feederdata
	dump[2], feederdata.title = feederdata, i18n("pet_text_05")
	local config = dump
	self.players = config
	self.fields.List:setNumItems(#self.players)
	self.fields.scroll_page:setNumItems(#self.petMap)
end
function PetLordViewPanel:onItemRenderer(index, obj)
	local cfg = self.players[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local c1 = obj:getController("c1")
	_fields.Text_title:setString(cfg.title)
	local data = cfg.data
	if data then
		local uInfo = data.uInfo
		_fields.Com_head:setHeadSprite(uInfo.imageId, uInfo.avatar)
		_fields.Com_head:getLoadHead():setAlpha(1)
		local name = mailFunctions:getWrappedName(uInfo.abbr, uInfo.name)
		_fields.Text_name:setString(name)
		_fields.Text_time:setString(os.date("!%Y.%m.%d %H:%M", data.time))
		c1:setSelectedIndex(0)
	else
		_fields.Com_head:setHeadSprite("icon_nouser.png")
		_fields.Com_head:getLoadHead():setAlpha(0.2)
		_fields.Text_noData:setString(i18n("pet_text_06"))
		c1:setSelectedIndex(1)
	end
	_fields.Com_head:setHandle(function()
		local data = cfg.data
		if data then
			local uInfo = data.uInfo
			cfg = nil
			;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;(nil).playerID = uInfo.uid
			;(nil).kid = uInfo.kid
			SoraDSendMessage(nil)
			return
		end
		local canUnlock, tableUnlockData = petCtrl:petIsCanUnlock(self.curPet.pid)
		if not canUnlock then
			cfg = uInfo.kid
			uInfo.kid.msg = "MESSAGE_PET_ITEM_GUILD"
			uInfo.kid.itemID = tableUnlockData.debris.debrisid
			SoraDSendMessage(uInfo.kid)
		else
			cfg = nil
			;(nil).petid = self.curPet.pid
			uiManager:show("PetFguiView", nil)
			self:closePanel()
		end
	end)
end
return PetLordViewPanel
