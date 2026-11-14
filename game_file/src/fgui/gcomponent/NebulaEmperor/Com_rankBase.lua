local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankBase = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaEmperor/Com_rankBase", Com_rankBase)
function Com_rankBase:onInit()
	self.selfPlayerID = gametop.playertop_:getPlayerID() or 0
	if not SoraDFIsRA() then
		self.fields.Load_bg:fix()
		self.fields.Load_rank:fixPos()
		self.fields.Text_rank:fixPos()
		self.fields.bg_rank:fixPos()
	end
end
function Com_rankBase:onShow()
end
function Com_rankBase:initRankBaseData(data)
	local rank = data.rank
	if 0 < rank and rank <= 3 then
		self.controllers.c_top3:setSelectedIndex(0)
		self.fields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		self.fields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		self.controllers.c_top3:setSelectedIndex(1)
		local rankMax = data.rankMax or 150
		if 0 < rank and rank <= rankMax then
			self.fields.Text_rank:setString(tostring(rank))
		else
			self.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
		self.fields.Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.uid == self.selfPlayerID then
		self.fields.Load_bg:setURL("frame_alliance_pank_05.png")
	end
	if data.isOwnRank then
		self.controllers.c_type:setSelectedIndex(1)
	else
		self.controllers.c_type:setSelectedIndex(0)
	end
end
function Com_rankBase:initData2(data)
	local rank = data.rank
	if 0 < rank and rank <= 3 then
		self.controllers.c_top3:setSelectedIndex(0)
		self.fields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		self.fields.Load_bg:setURL(string.format("frame_lord_mingci%02d.png", rank))
	else
		self.controllers.c_top3:setSelectedIndex(1)
		local rankMax = data.rankMax or 999999
		if 0 < rank and rank < rankMax then
			self.fields.Text_rank:setString(tostring(rank))
		else
			self.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
		self.fields.Load_bg:setURL("frame_xybz_bg_07.png")
	end
	if data.isSelf then
		self.fields.Load_bg:setURL("frame_xybz_bg_07.png")
		self.fields.Image_self:setVisible(true)
	else
		self.fields.Image_self:setVisible(false)
	end
	if data.isOwnRank then
		self.controllers.c_type:setSelectedIndex(1)
	else
		self.controllers.c_type:setSelectedIndex(0)
	end
end
return Com_rankBase
