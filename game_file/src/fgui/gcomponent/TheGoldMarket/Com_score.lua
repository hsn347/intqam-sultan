local goldSoukCtrl = SoraDGetCtrl("goldSoukCtrl")
local goldSoukRead = include("goldSoukRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_score = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Com_score", Com_score)
function Com_score:onInit()
	self.cfg = goldSoukRead.getRewardCfg()
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	self.fields.Button_tip:addClickListener(handler(self, self.onBtnTipClick))
	self.fields.List_box:fixPos()
	self.fields.Button_tip:fixPos()
end
function Com_score:onBoxRenderer(index, obj)
	obj:initData(self.cfg[index + 1])
end
function Com_score:onShow()
end
function Com_score:initData()
	_ENV = nil
	;(nil).num = goldSoukCtrl:getScore()
	self.fields.Text_score:setString(i18n("GoldSouk_text_01", nil))
	self:setBarValue()
	self.fields.List_box:setNumItems(#self.cfg)
end
function Com_score:setBarValue()
	local myScore = goldSoukCtrl:getScore()
	if myScore >= self.cfg[#self.cfg].integral then
		self.fields.Bar_score:setBarValue(100)
		return
	end
	local val = 0
	local index = 1
	for k, v in ipairs(self.cfg) do
		if myScore <= v.integral then
			index = k
			break
		end
	end
	local tempPre = 100 / #self.cfg
	if index == 1 then
		val = myScore / self.cfg[index].integral * tempPre
	else
		val = (index - 1) * tempPre + (myScore - self.cfg[index - 1].integral) * tempPre / (self.cfg[index].integral - self.cfg[index - 1].integral)
	end
	print("val=======", myScore, index, val)
	self.fields.Bar_score:setBarValue(val)
end
function Com_score:onBtnTipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("GoldSouk_text_07")
	uiManager:show("RuleView", nil)
end
return Com_score
