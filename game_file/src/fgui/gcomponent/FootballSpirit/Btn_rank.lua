local footballElfRead = include("footballElfRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://FootballSpirit/Btn_rank", Btn_rank)
function Btn_rank:onInit()
	self.fields.mv_jb:setAllFrameName("dh_shijiebeijb_%.2d.png", 1)
	self.fields.title:setString(i18n("common_text_851"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.touch:addClickListener(handler(self, self.onBtnRank))
end
function Btn_rank:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Btn_rank:onShow()
	self.reward = footballElfRead.getRankTop2Arawd()
	self.fields.List_reward:setNumItems(#self.reward)
end
function Btn_rank:onBtnRank()
	SoraDPlaySound()
	uiManager:show("FootballSpiritRank")
end
return Btn_rank
