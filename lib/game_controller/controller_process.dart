part of 'game_controller.dart';

GameSetting gameSetting = GameSetting();

enum GameControl {
  gameStarted,
  gamePaused,
  gameResumed,
  weaponBuilding,
  weaponSelected,
  /*change type */
  weaponBuildDone,
  weaponDestroyed,
  weaponShowAction,
  weaponShowProfile,
  enemySpawn,
  enemyMissed,
  enemyKilled,
  enemyNexWave,
}

class GameInstruction {
  GameControl instruction;
  GameComponent source;

  GameInstruction(this.source, this.instruction);
  void process(GameController controller) {
    switch (instruction) {
      case GameControl.gameStarted:
        controller.gameRef.started;
        break;
      case GameControl.gameResumed:
        controller.gameRef.resumeEngine();
        break;
      case GameControl.gamePaused:
        controller.gameRef.pauseEngine();
        break;
      case GameControl.weaponBuilding:
        WeaponViewWidget.hide();
        // controller.gameRef.read<InventoryBloc>().add();
        WeaponComponent? component = controller.buildWeapon(source.position,
            controller.gameRef.read<InventoryBloc>().state.weapon);
        if (component != null) {
          controller.add(component);
          controller.buildingWeapon?.removeFromParent();
          controller.buildingWeapon = component;
          component.blockMap = component.collision(controller.gateStart) ||
              component.collision(controller.gateEnd) ||
              controller.gameRef.mapController.testBlock(component.position);
        }
        break;
      case GameControl.weaponSelected:
        WeaponViewWidget.hide();
        // controller.gameRef.weaponFactory.select(source as SingleWeaponView);
        if (controller.buildingWeapon != null) {
          controller.send(
              controller.buildingWeapon!, GameControl.weaponBuilding);
        }
        break;
      case GameControl.weaponBuildDone:
        // controller.buildingWeapon.buildDone = true;
        controller.onBuildDone(source as WeaponComponent);
        controller.gameRef.mapController.astarMapAddObstacle(source.position);
        controller.buildingWeapon = null;
        controller.processEnemySmartMove();
        break;
      case GameControl.weaponDestroyed:
        WeaponViewWidget.hide();
        controller.onDestroy(source as WeaponComponent);
        controller.gameRef.mapController
            .astarMapRemoveObstacle(source.position);
        controller.processEnemySmartMove();
        break;
      case GameControl.enemySpawn:
        controller.enemyFactory.start();
        break;
      case GameControl.enemyMissed:
        controller.gameRef.read<StageBarBloc>().add(const SbAddMissed(1));

        break;
      case GameControl.enemyKilled:
        controller.gameRef.read<StageBarBloc>().add(const SbAddKilled(1));

        break;
      case GameControl.enemyNexWave:
        controller.gameRef.read<StageBarBloc>().add(const SbAddWave(1));

        break;
      case GameControl.weaponShowAction:
        WeaponViewWidget.show(source as WeaponComponent);
        break;
      default:
    }
  }
}
