local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local activity_9001731_Read = include("activity_9001731_Read")
local baseComponent = require("fgui.base.baseComponent")
local Btn_chess = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001731/Btn_chess", Btn_chess)
function Btn_chess:onInit()
	self.fields.mv_xz:setAllFrameName("dh_zndzf_pyui_%.2d.png", 1)
	self.fields.mv_xx:setAllFrameName("G_heroweapon_jj_03_%.2d.png", 1)
	self:addClickListener(handler(self, self.onClick_Button_chess))
	self.fields.mv_xz:setVisible(false)
	self.fields.sel:setVisible(false)
	self.fields.mv_xx:setVisible(false)
end
function Btn_chess:onShow()
end
function Btn_chess:initData(playerID, data)
	self.playerID = playerID
	self.data = data
	self.canMove = false
	self.controllers.c1:setSelectedIndex(self.playerID - 1)
	self:setStatus(self.data.status)
end
function Btn_chess:setStatus(status)
	self.data.status = status
	self.controllers.c2:setSelectedIndex(status == gFlyingChessPieceStatus.REACH and 1 or 0)
end
function Btn_chess:setReadyGoAni()
	self.canMove = true
	self:setGo()
end
function Btn_chess:setGo()
	self.fields.mv_xz:setVisible(true)
	self.fields.sel:setVisible(true)
	self.transitions.t0:play(-1, 0, 0, -1)
end
function Btn_chess:setIdle()
	self.canMove = false
	self.fields.mv_xz:setVisible(false)
	self.fields.sel:setVisible(false)
	self.transitions.t0:stop()
	self.fields.icon:setScale(1)
end
function Btn_chess:setReachAni()
	self.canMove = false
	self.fields.mv_xx:setVisible(true)
	self.transitions.t1:play(function()
		self:setStatus(gFlyingChessPieceStatus.REACH)
		self.fields.mv_xx:setVisible(false)
	end)
end
function Btn_chess:setShowModel(ret)
	self:setScale(ret and 0.5 or 1)
end
function Btn_chess:getStatus()
	return self.data.status
end
function Btn_chess:getPathIndex()
	return self.data.pathIndex
end
function Btn_chess:getChessID()
	return self.data.chessID
end
function Btn_chess:setPathIndex(pathIndex)
	self.data.pathIndex = pathIndex
end
function Btn_chess:getSafeGrid()
	local grid = self.data.pathIndex > 0 and activity_9001731_Read.getGridByPathIndex(self.playerID, self.data.pathIndex)
	if activity_9001731_Read.isSafeMapNumber(grid) then
		return grid
	end
end
function Btn_chess:onClick_Button_chess(context)
	if activity_9001731_Ctrl:getSelfChessPlayer() == self.playerID and self.data.status ~= gFlyingChessPieceStatus.REACH and self.canMove then
		SoraDPlaySound()
		activity_9001731_Ctrl:reqChoose(self.data.chessID)
	end
end
return Btn_chess
