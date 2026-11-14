local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_cityWall = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_cityWall", Com_cityWall)
function Com_cityWall:onInit()
	self.cityWallHp = towerDefendRead.getGameConfig().wallHp
	self:setValue()
end
function Com_cityWall:getAttack(damage)
	if damage <= 0 then
		return
	end
	self.cityWallHp = self.cityWallHp - damage
	self:setValue()
	if 0 >= self.cityWallHp then
		_ENV = self
		self.msg = "MESSAGE_TOWER_DEFEND_GAME_FAIL"
		self.fail = true
		SoraDSendMessage(self)
		return
	end
	if self.cityWallHp < towerDefendRead.getGameConfig().wallHp * 0.4 then
		_ENV = towerDefendRead.getGameConfig().wallHp * 0.4
		;(towerDefendRead.getGameConfig().wallHp * 0.4).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
		SoraDSendMessage(towerDefendRead.getGameConfig().wallHp * 0.4)
	end
end
function Com_cityWall:setValue()
	if self.cityWallHp < 0 then
		self.cityWallHp = 0
	end
	self.fields.Text_hp:setString(self.cityWallHp .. "/" .. towerDefendRead.getGameConfig().wallHp)
	self.fields.bar:setFillAmount(self.cityWallHp / towerDefendRead.getGameConfig().wallHp)
end
function Com_cityWall:onShow()
end
return Com_cityWall
