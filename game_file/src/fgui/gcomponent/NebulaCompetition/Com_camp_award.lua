local baseComponent = require("fgui.base.baseComponent")
local Com_camp_award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_camp_award", Com_camp_award)
function Com_camp_award:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.list_win:setItemRenderer(handler(self, self.onWinRenderer))
	self.fields.list_lose:setItemRenderer(handler(self, self.onLoseRenderer))
end
function Com_camp_award:onShow()
end
function Com_camp_award:initData(data, index)
	if index == 7 then
		self.fields.title:setString(i18n("Nebula_Competition_text_12"))
	else
		_ENV = i18n("Nebula_Competition_text_12")
		i18n("Nebula_Competition_text_12").num = index
		self.fields.title:setString(i18n("common_text_3198", i18n("Nebula_Competition_text_12")))
	end
	dump(data[1].reward, "data[1].reward")
	_UPVALUE2_ = "data[1].reward"
	;("data[1].reward")[1] = "id"
	;("data[1].reward")[2] = "num"
	self.winRewards = serviceFunctions.tableFormat(data[1].reward, "data[1].reward")
	_UPVALUE2_ = "data[1].reward"
	;("data[1].reward")[1] = "id"
	;("data[1].reward")[2] = "num"
	self.loseRewards = serviceFunctions.tableFormat(data[2].reward, "data[1].reward")
	self.fields.list_win:setNumItems(#self.winRewards)
	self.fields.list_lose:setNumItems(#self.loseRewards)
	self.fields.list_win:scrollToView(0, false, false)
	self.fields.list_lose:scrollToView(0, false, false)
end
function Com_camp_award:onWinRenderer(index, obj)
	obj:initData(self.winRewards[index + 1].id, self.winRewards[index + 1].num)
end
function Com_camp_award:onLoseRenderer(index, obj)
	obj:initData(self.loseRewards[index + 1].id, self.loseRewards[index + 1].num)
end
return Com_camp_award
