local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self.fields.icon:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.List_item:fixPos()
	self.fields.icon:setVisible(false)
	self.fields.Text_rank:setVisible(false)
	self.fields.Usm_highlight:setPrepareCallback(function()
		local effect = self.fields.Usm_highlight:getCriSprite()
		effect:setOpacity(0)
		effect:runAction(cca.fadeIn(0.3))
		self.fields.Usm_highlight:getCriSprite():start()
	end)
end
function Com_rankSingle:initData(index, data, flag)
	self.person = flag == "person" and true or false
	self.data = data
	self.reward = data.reward
	local flag = index <= 3 and true or false
	if flag then
		self.fields.icon:setURL("icon_ranking_" .. index .. ".png")
		self.fields.icon:setVisible(true)
	else
		local str = data.rankstart
		if data.rankstart ~= data.rankend then
			str = string.format("%d-%d", data.rankstart, data.rankend)
		end
		self.fields.Text_rank:setString(str)
		self.fields.Text_rank:setVisible(true)
	end
	self.fields.bg:setVisible(bit.band(index, 1) == 0 and true or false)
	self:showEffect()
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_item:setNumItems(table.nums(self.reward))
end
function Com_rankSingle:onItemRenderer(index, object)
	local item = self.reward[index + 1]
	if item.id then
		object:initData(item.id, item.count)
	end
end
function Com_rankSingle:showEffect()
	local score = self.person and romeActivityCtrl.memberRank or romeActivityCtrl.allianceRank
	local flag = self.data.rankstart == self.data.rankend and true or false
	flag = score == self.data.rankstart and true or false
	if flag or score >= self.data.rankstart and score <= self.data.rankend then
		self.fields.Usm_highlight:setVisible(true)
	else
		self.fields.Usm_highlight:setVisible(false)
	end
end
function Com_rankSingle:onShow()
end
return Com_rankSingle
