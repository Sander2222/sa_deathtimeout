Config = {}

Config.Timeout = 30 -- In Sekunden angeben 

Config.RemoveTimeout = 'removetimeout'
Config.RemoveTimeoutRadius = 'removeradius'
Config.Groups = {'admin', 'mod'}

Config.Locals = {
    ['TargetRemoveTimeout'] = 'Dir wurde dein Timeout removed',
    ['PlayerRemovedTimeout'] = 'Du hast der Spieler ID %s den Timeout entfernt',
    ['RemovedSelfTimeout'] = 'Du hast dir selber den Timeout entfernt',
    ['NoPlayerWithTimeOut'] = 'Es gibt keinen Spieler der einen Timeout hat mit dieser ID',
    ['NoRights'] = 'Du hast dazu keine Rechte',
    ['EnterNumber'] = 'Du musst einen Radius als Zahl angeben'
}