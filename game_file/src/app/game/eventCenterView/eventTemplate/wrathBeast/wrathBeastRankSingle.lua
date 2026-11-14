local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local wrathBeastRankSingle = class("wrathBeastRankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("wrathBeastRankSingle")
	end
	return target
end)
function wrathBeastRankSingle:ctor()
	self.handle = nil
	self:initWidget()
end
function wrathBeastRankSingle:initWidget()
	self.imageHead = SoraDGetChildByName(self, "Image_Head")
	self.imageHead:setTouchEnabled(true)
	self.imageHead:setSwallowTouches(false)
	self.imageHead:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textNum = SoraDGetChildByName(self, "Text_Num")
	SoraDSetTextWidthHeight(self.textNum, cc.size(self.textNum:getContentSize().width, 23))
	self.imageRank = SoraDGetChildByName(self, "icon_ranking_1_1")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.imageBg = SoraDGetChildByName(self, "Image_1")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setTouchEnabled(true)
	self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function wrathBeastRankSingle:initData(data, otherData)
	self.data = data
	self:setHeadSprite(data.imageId, data.avatar)
	if data.rank then
		local isTopThree = data.rank >= 1 and data.rank <= RANK_TOP_SPECIAL
		if isTopThree then
			self.imageRank:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		end
		if not otherData.isSelf then
			if isTopThree then
				self.imageBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
			else
				self.imageBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
			end
			if tonumber(data.uid) == gametop.playertop_:getPlayerID() then
				self.imageBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
			end
		end
		self.imageRank:setVisible(isTopThree)
		self.textRank:setVisible(not isTopThree)
		if data.rank > 0 then
			self.textRank:setString(data.rank)
		else
			self.textRank:setString(i18n("common_text_827"))
		end
	else
		self.imageRank:setVisible(false)
		self.textRank:setVisible(false)
	end
	if data.allianceAbbr and data.allianceAbbr ~= "" then
		_ENV = i18n("common_text_827")
		i18n("common_text_827").abbr = data.allianceAbbr
		i18n("common_text_827").name = data.nickName
		self.textName:setString(i18n("common_text_186", i18n("common_text_827")))
	else
		self.textName:setString(data.nickName)
	end
	self.textNum:setString(string.formatnumberthousands(data.score))
	if otherData.isSelf then
		self.layerTouch:setTouchEnabled(true)
		self.imageHead:setTouchEnabled(false)
	else
		self.layerTouch:setTouchEnabled(false)
		self.imageHead:setTouchEnabled(true)
	end
end
function wrathBeastRankSingle:setHeadSprite(imageId, avatar)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local info = lordInfoCtrl:getBaseInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	SoraDGetHeadFromManager(self.imageHead, imageId, avatar)
end
function wrathBeastRankSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.data)
		end
	end
end
function wrathBeastRankSingle:setClickHandle(handle)
	self.handle = handle
end
return wrathBeastRankSingle
