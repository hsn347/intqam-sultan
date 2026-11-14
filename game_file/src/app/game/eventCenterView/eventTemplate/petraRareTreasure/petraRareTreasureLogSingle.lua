local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureRead = include("petraRareTreasureRead")
local petraRareTreasureLogSingle = class("petraRareTreasureLogSingle", function(target)
	return target
end)
function petraRareTreasureLogSingle:ctor()
	self.itemA = SoraDGetChildByName(self, "Node_itemCopy")
	self.itemA = include("commonItemAward").new(self.itemA)
	self.imageHead = SoraDGetChildByName(self, "Image_Head")
	self.imageHead:setTouchEnabled(true)
	self.imageHead:addTouchEventListener(handler(self, self.queryPlayerInfo))
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.posX = self.textTime:getPositionX() + (SoraDFIsRA() and 5 or -5)
	self.scroll = nil
	self.singleIsMoved = false
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function petraRareTreasureLogSingle:initData(data, parent, typeShow)
	self.imageHead:setVisible(typeShow)
	self.scroll = parent
	self:setHeadSprite(data.iconID, data.avatar)
	self.nickName = data.nickName
	self.uid = data.uid
	self.kid = data.kid
	self.allianceName = data.allianceAbbr
	local itemInfo = petraRareTreasureRead:getSelectItem(data.bestTreasureId or data[2])
	self.itemA:setOwnView(self.scroll:getParent():getParent())
	self.itemA:setOwnScroll(self.scroll)
	self.itemA:initData(itemInfo.id, itemInfo.count)
	self.textTime:setVisible(true)
	self.textTime:setString(os.date("!%m/%d %H:%M:%S", data.time or data[1]))
	if data.allianceAbbr and data.allianceAbbr ~= "" then
		petraRareTreasureRead = os.date("!%m/%d %H:%M:%S", data.time or data[1])
		os.date("!%m/%d %H:%M:%S", data.time or data[1]).abbr = data.allianceAbbr
		os.date("!%m/%d %H:%M:%S", data.time or data[1]).name = data.nickName
		self.textName:setString(i18n("common_text_186", os.date("!%m/%d %H:%M:%S", data.time or data[1])))
	else
		self.textName:setString(data.nickName)
	end
	if not typeShow then
		self.textTime:setPositionX(self.imageHead:getPositionX() + (SoraDFIsRA() and 100 or -100))
	else
		self.textTime:setPositionX(self.posX)
	end
	SoraDGetAutoHeightLabel(self.textName, 190)
end
function petraRareTreasureLogSingle:setHeadSprite(imageId, avatar)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local info = lordInfoCtrl:getBaseInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	SoraDGetHeadFromManager(self.imageHead, imageId, avatar)
end
function petraRareTreasureLogSingle:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self.scroll)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function petraRareTreasureLogSingle:queryPlayerInfo(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self.scroll)
		self._queryInfo = true
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		_ENV = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(self.uid, self.kid, nil)
	end
end
return petraRareTreasureLogSingle
