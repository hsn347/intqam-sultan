local baseComponent = require("fgui.base.baseComponent")
local Com_MiningMeteorites_Reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MiningMeteorites/Com_MiningMeteorites_Reward", Com_MiningMeteorites_Reward)
function Com_MiningMeteorites_Reward:onInit()
end
function Com_MiningMeteorites_Reward:onShow()
end
function Com_MiningMeteorites_Reward:initData(index, reward)
	_ENV = nil
	;(nil).num = index
	self.fields.txt_title:setString(i18n("mining_meteorites_18", nil))
	self.fields.item:initData(reward[1], reward[2])
end
return Com_MiningMeteorites_Reward
