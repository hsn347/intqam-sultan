local scrollNode = include("scrollNode")
local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = SoraDGetCtrl("remainsWarCtrl")
local remainsWarRead = include("remainsWarRead")
local remainsWarBuffUse = class("remainsWarBuffUse", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarBuffUse")
	end
	return target
end)
function remainsWarBuffUse:ctor()
	self:initWidget()
	self:req4Data()
end
function remainsWarBuffUse:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_314"))
	self.Node_Content = SoraDGetChildByName(self, "Node_Content")
	self.Node_title = SoraDGetChildByName(self.Node_Content, "Node_title")
	self.Image_head = SoraDGetChildByName(self.Node_title, "Image_head")
	self.Image_itemBg = SoraDGetChildByName(self.Node_title, "Image_itemBg")
	self.Text_name = SoraDGetChildByName(self.Node_title, "Text_name")
	self.Text_des = SoraDGetChildByName(self.Node_title, "Text_des")
	self.proBar = SoraDGetExtendChildFromCCSByName(self.Node_title, "CCS_citybuffProgressBar_bufftime")
	SoraDGetChildByName(self, "Text_tips"):setString(i18n("remains_text_345"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_player")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
end
function remainsWarBuffUse:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA", handler(self, self.initPlayerData))
end
function remainsWarBuffUse:initData(buffData)
	dump(buffData, "==buffData==")
	self.buffData = buffData
	self.tableBuff = remainsWarRead.getBuffShowData(buffData)
	local itemDesRead = include("itemDesRead")
	self.Image_head:loadTexture(SoraDCheckPNG(self.tableBuff.icon), ccui.TextureResType.plistType)
	self.Image_itemBg:loadTexture(itemDesRead.getBgByLv(self.tableBuff.quaitly), ccui.TextureResType.plistType)
	self.Text_name:setString(self.tableBuff.buffname)
	self.Text_des:setString(self.tableBuff.bufdes)
	self.proBar:initRemainsWarBuff(buffData)
	self.proBar:setTimeEndListener(function()
		self:close(nil, ccui.TouchEventType.ended)
	end)
end
function remainsWarBuffUse:req4Data()
	local mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
	remainsWarCtrl:reqRemainsWarPlayerPointsList(mapId)
	SoraDShowLoading(self)
end
function remainsWarBuffUse:initPlayerData(target, data)
	SoraDCloseLoading(self)
	local selfCamp = remainsWarCtrl:getCampType(SoraDGetCtrl("allianceMgr"):getOwnTeamID())
	if tonumber(selfCamp) == RW_CAMP.SOUTH then
		self.playerData = data.playerPointsList[RW_CAMP.NORTH_KEY]
	else
		self.playerData = data.playerPointsList[RW_CAMP.SOUTH_KEY]
	end
	dump(self.playerData, "==self.playerData==")
	local _ENV, playerData = dump, dump
	for i, v in ipairs(self.playerData) do
		if v.isIn then
			table.insert(playerData, v)
		end
	end
	self.playerData = playerData
	local sSize = self.scroll:getContentSize()
	local itemH = 100
	local sH = math.max(sSize.height, #self.playerData * itemH)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.playerData) do
		local item = self.Node_single:clone()
		item:setVisible(true)
		item:addTo(self.scroll)
		item:setPosition(sSize.width / 2, sH - (i - 1) * itemH)
		self:initItemSingle(item, v)
	end
end
function remainsWarBuffUse:initItemSingle(item, data)
	local Button_use = SoraDGetChildByName(item, "Button_use")
	Button_use:setTitleText(i18n("common_text_314"))
	Button_use = SoraDCreatePanelByCloneNode(Button_use, "scrollNode")
	Button_use:setSwallowTouches(false)
	Button_use:addTouchEventListener(handler(self, self.btnClickCallBack))
	Button_use:setScroll(self.scroll)
	Button_use:setTag(data.uid)
	item.Button_use = Button_use
	local head = SoraDGetExtendChildFromCCSByName(item, "CCS_commonHead_head")
	head:setScale(1.0)
	head:setTouchEnabled(false)
	SoraDGetHeadFromManager(head, data.headid, data.avatar)
	local name = SoraDGetCtrl("lordInfoCtrl"):getSplitName(data)
	SoraDGetChildByName(item, "Text_name"):setString(name)
	if data.cityLevel then
		local Sprite_castle = SoraDGetChildByName(item, "Sprite_castle")
		local Text_castleLv = SoraDGetChildByName(item, "Text_castleLv")
		SoraDGetCtrl("lordInfoCtrl"):setCastleLv(data.cityLevel, Sprite_castle, Text_castleLv)
	end
end
function remainsWarBuffUse:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mapId = gametop.playertop_:getMapID()
		remainsWarCtrl:reqThrowBossSkill(mapId, button:getTag(), self.buffData.src)
		self:close(button, type)
	end
end
return remainsWarBuffUse
