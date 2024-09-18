module.exports = {
    proxyInstance(Instance, getModule) {
        return class ProxiedInstance extends Instance {
            constructor(...args) {
                super(...args);
                this.installingModules = new Set();
            }

            async installModule(moduleName) {
                const installedModules = await this.getInstalledModuleNames();

                // Vérifier si le module est déjà installé
                if (installedModules.includes(moduleName)) {
                    return Promise.resolve();
                }

                // Vérifier si le module est déjà en cours d'installation (boucle de dépendances)
                if (this.installingModules.has(moduleName)) {
                    return Promise.reject('ERROR_MODULE_DEPENDENCIES');
                }

                // Récupérer le module
                const module = getModule(moduleName);
                if (!module) {
                    return Promise.reject('ERROR_MODULE_UNKNOWN');
                }

                // Ajouter le module en cours d'installation
                this.installingModules.add(moduleName);

                // Installer les dépendances
                try {
                    for (let dependency of module.requires) {
                        if (!installedModules.includes(dependency)) {
                            await this.installModule(dependency);
                        }
                    }

                    // Installer le module une fois que les dépendances sont installées
                    await this.simpleInstallModule(moduleName);
                } catch (error) {
                    // Gestion des erreurs liées aux dépendances
                    if (error === 'MISSING_DEPENDENCY_ERROR' || error === 'UNKNOWN_DEPENDENCY_ERROR') {
                        return Promise.reject('ERROR_MODULE_DEPENDENCIES');
                    }
                    return Promise.reject(error);
                } finally {
                    // Retirer le module de la liste des modules en cours d'installation
                    this.installingModules.delete(moduleName);
                }

                return Promise.resolve();
            }
        };
    }
};
