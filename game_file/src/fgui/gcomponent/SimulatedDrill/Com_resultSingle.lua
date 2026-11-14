local baseComponent = require("fgui.base.baseComponent")
local Com_resultSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_resultSingle", Com_resultSingle)
function Com_resultSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_resultSingle:onShow()
end
function Com_resultSingle:initData(data, isWin, rank)
	self.controllers.c1:setSelectedIndex(isWin and 0 or 1)
	self.fields.bg:setVisible(rank % 2 == 0)
	if 0 < rank and rank <= 3 then
		self.controllers.rank:setSelectedIndex(rank)
	else
		self.controllers.rank:setSelectedIndex(0)
		self.fields.Text_rank:setString(tostring(rank))
	end
	if data then
		self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
		self.fields.Text_name:setString(data.nickName .. "#" .. data.fromKid)
		local totalFc = string.formatnumberthousands(data.totalFc)
		self.fields.Text_power:setString(totalFc)
		local score = string.formatnumberthousands(data.killArmyFc or 0)
		self.fields.Text_score:setString(score)
	end
end
return Com_resultSingle
