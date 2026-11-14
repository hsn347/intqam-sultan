local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local eventCrazyDropRankSingle = class("eventCrazyDropRankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventCrazyDropRankSingle")
	end
	return target
end)
function eventCrazyDropRankSingle:ctor()
	self.Image_curBg = SoraDGetChildByName(self, "Image_curBg")
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
end
function eventCrazyDropRankSingle:initData(data)
	if data.rank <= RANK_TOP_SPECIAL then
		self.Image_curBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
		self.Sprite_index:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		self.Sprite_index:setVisible(true)
		self.Text_index:setVisible(false)
	else
		local isMe = data.uid == lordInfoCtrl:getLordInfo().base.uid
		self.Image_curBg:loadTexture(isMe and "frame_alliance_pank_05.png" or "frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		self.Sprite_index:setVisible(false)
		self.Text_index:setVisible(true)
		self.Text_index:setString(data.rank)
	end
	if data.allianceAbbr then
		_ENV = ccui.TextureResType.plistType
		ccui.TextureResType.plistType.abbr = data.allianceAbbr
		ccui.TextureResType.plistType.name = data.nickName
		if i18n("common_text_186", ccui.TextureResType.plistType) then
			goto lbl_81
		end
	end
	::lbl_81::
	self.Text_name:setString(data.nickName)
	self.Text_num:setString(string.formatnumberthousands(data.score))
	self.ccs_head:setHeadSprite(data.iconID, data.avatar)
	self.ccs_head:setPlayerID(data.uid)
end
return eventCrazyDropRankSingle
