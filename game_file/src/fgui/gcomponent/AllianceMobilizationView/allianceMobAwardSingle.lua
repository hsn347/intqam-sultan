local MAX_AWARD_NUM = 5
local baseComponent = require("fgui.base.baseComponent")
local allianceMobAwardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMobilizationView/allianceMobAwardSingle", allianceMobAwardSingle)
function allianceMobAwardSingle:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_items:setAlignCenter(true)
	self.fields.Text_topOne:setString(i18n("alliance_flagname_01"))
	self.fields.Image_keyPoint:fix()
end
function allianceMobAwardSingle:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function allianceMobAwardSingle:onShow()
end
function allianceMobAwardSingle:initData(data, tag)
	self.data = data
	self.tag = tag
	if self.tag == 1 then
		self.fields.Image_keyPoint:setVisible(self.data.stage <= RANK_TOP_SPECIAL)
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c2:setSelectedIndex(0)
		_ENV = nil
		;(nil).num = self.data.stage
		self.fields.Text_rank:setString(i18n("common_text_3198", nil))
		self:setHeight(190)
	else
		self.fields.Image_keyPoint:setVisible(false)
		_ENV = i18n("common_text_3198", nil)
		i18n("common_text_3198", nil).num = self.data.rank
		self.fields.Text_rank:setString(i18n("common_text_617", i18n("common_text_3198", nil)))
		if self.data.rank <= RANK_TOP_SPECIAL then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.icon:setSpriteFrame("icon_ranking_" .. self.data.rank .. ".png")
			if self.data.rank == 1 then
				self.controllers.c2:setSelectedIndex(1)
				local flagNode = SoraDGetAllianceFlagByFid(17)
				flagNode:setScale(0.6)
				flagNode:setPosition(50, 50)
				self.fields.flag:setContent(flagNode)
				self:setHeight(350)
			else
				self.controllers.c2:setSelectedIndex(0)
				self:setHeight(190)
			end
			self.fields.Text_rank:fixPos()
			self.fields.icon:fixPos()
		else
			self.controllers.c1:setSelectedIndex(0)
			self.controllers.c2:setSelectedIndex(0)
			self:setHeight(190)
		end
	end
	self:setAward()
end
function allianceMobAwardSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(self.data.reward, nil)
	self.fields.List_items:setNumItems(math.min(#self.itemList, MAX_AWARD_NUM))
end
return allianceMobAwardSingle
