local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingleBase = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rankSingleBase", Com_rankSingleBase)
fgui.register_extension("ui://CommonNew/Com_rankSingleBaseSmall", Com_rankSingleBase)
function Com_rankSingleBase:onInit()
	self.selfPlayerID = gametop.playertop_:getPlayerID() or 0
	if not SoraDFIsRA() then
		self.fields.selfBg:fix()
		self.fields.Load_bg:fix()
		self.fields.Load_rank:fixPos()
		self.fields.Text_rank:fixPos()
		self.fields.bg_rank:fixPos()
	end
end
function Com_rankSingleBase:onShow()
end
function Com_rankSingleBase:setRank(rank)
	self.fields.Text_rank:setString(rank)
end
function Com_rankSingleBase:initRankBaseData(data)
	local rank = data.rank
	if type(rank) == "table" then
		local _rank = rank[1]
		if #rank == 1 or rank[1] == rank[2] then
			_rank = rank[1]
			if 0 < _rank and _rank <= 3 then
				self.controllers.c1:setSelectedIndex(_rank)
			else
				self.controllers.c1:setSelectedIndex(0)
				_ENV = 0
				;(0).rankStr = _rank
				self:updateTextRank(0)
			end
		else
			self.controllers.c1:setSelectedIndex(0)
			_ENV = 0
			;(0).rankStr = string.format("%d-%d", rank[1], rank[2])
			self:updateTextRank(0)
		end
	elseif 0 < rank and rank <= 3 then
		self.controllers.c1:setSelectedIndex(rank)
	else
		self.controllers.c1:setSelectedIndex(0)
		self:updateTextRank(data)
	end
	if data.isSelf or data.uid == self.selfPlayerID and 3 < rank then
		self.controllers.c_self:setSelectedIndex(1)
	else
		self.controllers.c_self:setSelectedIndex(0)
	end
	if data.isOwnRank then
		self.controllers.c_type:setSelectedIndex(1)
	else
		self.controllers.c_type:setSelectedIndex(0)
	end
end
function Com_rankSingleBase:updateTextRank(data)
	if data.rankStr then
		self.fields.Text_rank:setString(data.rankStr)
		return
	end
	local rank = data.rank
	local rankMax = data.rankMax or 999999
	if 0 < rank and rank <= rankMax then
		self.fields.Text_rank:setString(tostring(rank))
	else
		self.fields.Text_rank:setString(i18n("herobattle_text_05"))
	end
end
function Com_rankSingleBase:setTextRankSize(size)
	self.fields.Text_rank:setSize(size)
end
return Com_rankSingleBase
