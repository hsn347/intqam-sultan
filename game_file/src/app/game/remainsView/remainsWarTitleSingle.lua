local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local remainsWarTitleSingle = class("remainsWarTitleSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarTitleSingle")
	end
	return target
end)
function remainsWarTitleSingle:ctor()
	self:initWidget()
end
function remainsWarTitleSingle:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.head:setScale(1.0)
	self.head:setTouchEnabled(false)
end
function remainsWarTitleSingle:initData(tData)
	local data = tData.data
	self.head:setHeadSprite(data.headid, data.avatar)
	local name = data.nickName
	local allianceAbbr = data.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = data.nickName
		name = i18n("common_text_186", nil)
	end
	if data.kid then
		name = name .. "#" .. tostring(data.kid)
	end
	self.Text_name:setString(name)
	local titleData = remainsWarRead.getRuinsTitleConfig(tData.titleType)
	self.Text_title:setString(i18n(titleData.name))
	self.Text_des:setString(i18n(titleData.describe))
	self.Text_num:setString(string.formatnumberthousands(data[titleData.valuekey] or 0))
	self.Text_kill:setString(i18n(titleData.valuedes))
	self.Sprite_title:setSpriteFrame(titleData.icon)
	if tData.camp == _G.RW_CAMP.SOUTH then
		self.Sprite_camp:setSpriteFrame("frame_yjzz_newbg_02.png")
	else
		self.Sprite_camp:setSpriteFrame("frame_yjzz_newbg_03.png")
	end
end
return remainsWarTitleSingle
