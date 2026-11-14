local warTreasureRead = include("warTreasureRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local warTreasureCheerSingle = class("warTreasureCheerSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("warTreasureCheerSingle")
	end
	return target
end)
function warTreasureCheerSingle:ctor()
	self.allianceFlag = SoraDGetExtendChildFromCCSByName(self, "Node_flag")
	self.textNum = SoraDGetChildByName(self, "Text_num")
	self.spriteRank = SoraDGetChildByName(self, "Sprite_index")
	self.textRank = SoraDGetChildByName(self, "Text_index")
	self.textName = SoraDGetChildByName(self, "Text_name")
	self.textPower = SoraDGetChildByName(self, "Text_power")
	self.imageIcon = SoraDGetChildByName(self, "Image_Icon")
	self.btnCheer = SoraDGetChildByName(self, "Button_Cheer")
	self.btnCheer:setSwallowTouches(false)
	self.btnCheer:addTouchEventListener(handler(self, self.btnClickCheer))
	self.btnCheer:setTitleText(i18n("warSecrit_btn_04"))
	self.textMax = SoraDGetChildByName(self, "Text_Max")
	self.textMax:setString(i18n("hero_text_41"))
	self.imgCurBg = SoraDGetChildByName(self, "Image_barBg")
end
function warTreasureCheerSingle:initData(data, otherData)
	self.data = data
	self.itemID = otherData.itemID
	self.imgCurBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
	if data.rank <= RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local myAid = allianceMgr:getOwnAid()
	if data.aid == myAid and data.rank > RANK_TOP_SPECIAL then
		self.imgCurBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
	end
	_ENV = nil
	;(nil).abbr = self.data.abbr
	;(nil).name = self.data.name
	self.textName:setString(i18n("common_text_186", nil))
	local itemNum = self.itemID == 827101 and data.drumNum or data.medicineNum
	self.textNum:setString(string.formatnumberthousands(itemNum))
	self.imageIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.textPower:setString(string.formatnumberthousands(self.data.power))
	local isMax = warTreasureRead.getIsMax(self.itemID == 827101 and 1 or 2, itemNum)
	self.btnCheer:setVisible(not isMax)
	self.textMax:setVisible(isMax)
end
function warTreasureCheerSingle:btnClickCheer(button, type)
	if type == ccui.TouchEventType.ended then
		local num = backpackCtrl:getItemCount(self.itemID)
		if 0 < num then
			local panel = SoraDCreatePanel("warTreasureCheerPop")
			panel:initData(self.data, self.itemID)
			panel:show()
		else
			SoraDShowMsgTip(i18n(self.itemID == 827101 and "warSecrit_text_15" or "warSecrit_text_14"))
		end
	end
end
return warTreasureCheerSingle
