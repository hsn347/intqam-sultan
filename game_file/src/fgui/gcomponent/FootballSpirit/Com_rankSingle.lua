local textParser = include("textParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://FootballSpirit/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Load_bg:fix()
	self.fields.Load_rank:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.List_award:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_head:fixPos()
	self.fields.Text_score:fixPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
function Com_rankSingle:initData(style, data, index, isBottom)
	self.controllers.c2:setSelectedIndex(style)
	local rank = index
	if style == 0 then
		if data.empty then
			self.controllers.c3:setSelectedIndex(1)
			self.controllers.c1:setSelectedIndex(index % 2 == 1 and 0 or 1)
		else
			self.controllers.c3:setSelectedIndex(0)
			if rank <= RANK_TOP_SPECIAL and 0 < rank then
				self.fields.Load_rank:setVisible(true)
				self.fields.Load_rank:setSpriteFrame("icon_ranking_" .. rank .. ".png")
				self.fields.Text_rank:setVisible(false)
			else
				self.fields.Load_rank:setVisible(false)
				self.fields.Text_rank:setVisible(true)
				if rank <= 0 then
					self.fields.Text_rank:setString(i18n("common_text_827"))
				else
					if 5000 < rank then
						rank = "5000+"
					end
					self.fields.Text_rank:setString(rank)
				end
			end
			if isBottom then
				self.controllers.c1:setSelectedIndex(0)
			else
				self.controllers.c1:setSelectedIndex(index % 2 == 1 and 0 or 1)
			end
			self.fields.Text_score:setString(string.formatnumberthousands(data.ranking))
			self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceName, data.nickName))
			self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
			self.fields.Com_head:setPlayerID(data.uid)
		end
	else
		self.controllers.c3:setSelectedIndex(0)
		self.controllers.c1:setSelectedIndex(index % 2 == 1 and 0 or 1)
		if data.rank then
			if data.rank[1] == data.rank[2] then
				rank = data.rank[1]
				if rank <= RANK_TOP_SPECIAL and 0 < rank then
					self.fields.Load_rank:setVisible(true)
					self.fields.Load_rank:setSpriteFrame("icon_ranking_" .. rank .. ".png")
					self.fields.Text_rank:setVisible(false)
				else
					self.fields.Load_rank:setVisible(false)
					self.fields.Text_rank:setVisible(true)
					_ENV = ".png"
					;(".png").num = rank
					self.fields.Text_rank:setString(i18n("common_text_617", ".png"))
				end
			else
				rank = data.rank[1] .. "~" .. data.rank[2]
				self.fields.Load_rank:setVisible(false)
				self.fields.Text_rank:setVisible(true)
				_ENV = i18n("common_text_617", ".png")
				i18n("common_text_617", ".png").num = rank
				self.fields.Text_rank:setString(i18n("common_text_617", i18n("common_text_617", ".png")))
			end
		end
		_UPVALUE2_ = i18n("common_text_617", i18n("common_text_617", ".png"))
		i18n("common_text_617", i18n("common_text_617", ".png"))[1] = "id"
		i18n("common_text_617", i18n("common_text_617", ".png"))[2] = "count"
		self.awardList = serviceFunctions.tableFormat(data.reward, i18n("common_text_617", i18n("common_text_617", ".png")))
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
return Com_rankSingle
