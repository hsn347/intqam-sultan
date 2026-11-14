local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_RankInfoPanel = class("RoaringFlame_RankInfoPanel", baseFguiPanel)
local RANK_MAX = 4
function RoaringFlame_RankInfoPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_RankInfoPanel.super.ctor(self, ...)
	print("RoaringFlame_RankInfoPanel:ctor", self.viewName)
end
function RoaringFlame_RankInfoPanel:onInit()
	print("=======RoaringFlame_RankInfoPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_206"), handler(self, self.onClickClose))
	if not SoraDFIsRA() then
		self.fields.Com_info:fixChildrenPos()
	end
end
function RoaringFlame_RankInfoPanel:endShow()
	print("=======RoaringFlame_RankInfoPanel:endShow")
	local _fields = fguiHelper.get_fields(self.fields.Com_info)
	_UPVALUE3_ = self.fields.Com_info
	_ENV = nil
	;(nil).lv = 0
	_ENV = nil
	;(nil).lv = 1
	self.fields.Com_info[1] = i18n("common_text_277", nil)
	self.fields.Com_info[2] = i18n("common_text_277", nil)
	self.fields.Com_info[3] = i18n("atlantiswar_text_0141")
	self.fields.Com_info[4] = i18n("official_name_1")
	self.fields.Com_info[5] = i18n("official_name_1")
	self.fields.Com_info[6] = i18n("official_name_1")
	self.fields.Com_info[7] = i18n("official_name_1")
	self.fields.Com_info[8] = i18n("official_name_1")
	local self.fields.Com_info[9], config = i18n("official_name_1")
	for i, titleStr in ipairs(config) do
		local Text_rank = _fields["Text_rank_" .. i - 1]
		Text_rank:setString(titleStr)
	end
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.rankConfig = roaringFlameWarRead.getPermissionRankConfig()
	_fields.List:setNumItems(#self.rankConfig)
	_fields.List:resizeToFit(#self.rankConfig)
	local class = roaringFlameWarCtrl:getPlayerMemberClass()
	print("class====", class)
	_fields.me:setPositionX(_fields["Text_rank_" .. class]:getPositionX())
end
function RoaringFlame_RankInfoPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local cfg = self.rankConfig[index + 1]
	_fields.title:setString(i18n(cfg.des))
	_fields.bg:setVisible(index % 2 == 0)
	for i = 1, RANK_MAX do
		local Image_rank = _fields["Image_rank_" .. i - 1]
		Image_rank:setVisible(false)
	end
	for __, rank in ipairs(cfg.rank) do
		local Image_rank = _fields["Image_rank_" .. rank]
		Image_rank:setVisible(true)
	end
end
return RoaringFlame_RankInfoPanel
