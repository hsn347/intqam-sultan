local atlantisMemberRankInfoView = class("atlantisMemberRankInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisMemberRankInfoView")
	end
	return target
end)
local RANK_MAX = 5
function atlantisMemberRankInfoView:ctor()
	self.tablePosxRank, _UPVALUE0_ = nil, nil
	self:initWidget()
	self:initData()
end
function atlantisMemberRankInfoView:initWidget()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_rank")
	self.ccs_title:setTitle(i18n("common_text_206"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.Node_content = SoraDGetChildByName(self.scroll, "Node_content")
	self.tableTextRank = SoraDGetChildsArrayByName(self.Node_content, "Text_rank_", RANK_MAX, 0)
	self.tableImgLine = SoraDGetChildsArrayByName(self.Node_content, "Image_line_", RANK_MAX, 0)
	for i = 1, RANK_MAX do
		self.tablePosxRank[i - 1] = self.tableTextRank[i]:getPositionX()
	end
	self.imgBg1 = SoraDGetChildByName(self.Node_content, "Image_bg1")
	self.imgBg2 = SoraDGetChildByName(self.Node_content, "Image_bg2")
	self.Node_value = SoraDGetChildByName(self.Node_content, "Node_value")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
end
function atlantisMemberRankInfoView:initData()
	_UPVALUE4_ = nil
	_ENV = nil
	;(nil).lv = 0
	_ENV = nil
	;(nil).lv = 1
	_ENV = nil
	;(nil).lv = 2
	_ENV = nil
	;(nil).lv = 3
	;(nil)[1] = i18n("common_text_277", nil)
	;(nil)[2] = i18n("common_text_277", nil)
	;(nil)[3] = i18n("common_text_277", nil)
	;(nil)[4] = i18n("common_text_277", nil)
	;(nil)[5] = i18n("atlantiswar_text_0141")
	;(nil)[6] = i18n("atlantiswar_text_0141")
	;(nil)[7] = i18n("atlantiswar_text_0141")
	;(nil)[8] = i18n("atlantiswar_text_0141")
	;(nil)[9] = i18n("atlantiswar_text_0141")
	;(nil)[10] = i18n("atlantiswar_text_0141")
	;(nil)[11] = i18n("atlantiswar_text_0141")
	;(nil)[12] = i18n("atlantiswar_text_0141")
	;(nil)[13] = i18n("atlantiswar_text_0141")
	;(nil)[14] = i18n("atlantiswar_text_0141")
	;(nil)[15] = i18n("atlantiswar_text_0141")
	;(nil)[16] = i18n("atlantiswar_text_0141")
	;(nil)[17] = i18n("atlantiswar_text_0141")
	;(nil)[18] = i18n("atlantiswar_text_0141")
	;(nil)[19] = i18n("atlantiswar_text_0141")
	;(nil)[20] = i18n("atlantiswar_text_0141")
	;(nil)[21] = i18n("atlantiswar_text_0141")
	;(nil)[22] = i18n("atlantiswar_text_0141")
	;(nil)[23] = i18n("atlantiswar_text_0141")
	;(nil)[24] = i18n("atlantiswar_text_0141")
	local (nil)[25], config = i18n("atlantiswar_text_0141")
	for i, text in ipairs(self.tableTextRank) do
		text:setString(config[i])
	end
	local atlantiswar_team = require_data("atlantiswar_team").data
	local _ENV, list = "atlantiswar_team", "atlantiswar_team"
	for k, v in pairs(atlantiswar_team) do
		_ENV = i18n("atlantiswar_text_0141")
		i18n("atlantiswar_text_0141").permission = v.permission
		i18n("atlantiswar_text_0141").sort = v.sort
		table.insert(list, i18n("atlantiswar_text_0141"))
	end
	_UPVALUE2_, _UPVALUE1_ = text.setString, pairs(atlantiswar_team)
	text.setString[1] = "sort"
	text.setString[2] = "<"
	pairs(atlantiswar_team)[1] = text.setString
	serviceFunctions.sort(list, pairs(atlantiswar_team))
	local rowNum = #list
	local scrollH = 64
	for i, v in ipairs(list) do
		local data = atlantiswar_team[v.permission]
		local single = self.Node_single:clone()
		single:setVisible(true)
		single:addTo(self.Node_value)
		single:setPosition(SoraDFSign(320), -scrollH)
		SoraDGetAllChildFromWidget(single, single)
		single.Text_value:setString(i18n(data.des))
		local textH = SoraDGetAutoHeightLabelNew(single.Text_value)
		local maxH = textH + math.abs(single.Text_value:getPositionY()) * 2
		scrollH = scrollH + maxH
		single.Sprite_yes:setVisible(false)
		local posY = single.Text_value:getPositionY() - textH / 2
		for __, rank in ipairs(data.rank) do
			local Sprite_yes = single.Sprite_yes:clone()
			Sprite_yes:setVisible(true)
			Sprite_yes:addTo(single)
			Sprite_yes:setPosition(self.tablePosxRank[rank] - SoraDFSign(320), posY)
		end
	end
	self.imgBg1:setContentSize(cc.size(640, scrollH + 5))
	self.imgBg2:setContentSize(cc.size(640, scrollH + 2))
	local lineW = self.tableImgLine[1]:getContentSize().width
	for i, v in ipairs(self.tableImgLine) do
		v:setContentSize(cc.size(lineW, scrollH - 5))
	end
	scrollH = scrollH + 5
	scrollH = math.max(scrollH, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	self.Node_content:setPositionY(scrollH)
end
return atlantisMemberRankInfoView
