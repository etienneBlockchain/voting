# Voting Alyra

``` addRegister (address) ```

Permet d'insérer dans une liste blanche une adresse pouvant participer au vote.

---

``` statusVoting (WorkflowStatus) ```

Permet de modifier le statut du vote. Cette modification n'est disponible que pour l'administrateur.

---

``` nextStepVoting () ```

Permet de passer automatiquement au statut de vote suivant. Cette modification n'est disponible que pour l'administrateur.


---

``` voting (uint) ```

Enregistre le vote d'une adresse préalablement ajoutée à la liste blanche.

---

``` createProposal (string) ```

Permet de créer une proposition de vote.

---

``` checkPropalExist (string) private ```

Permet de vérifier si une proposition de vote existe déjà. Cette fonction n'est disponible qu'en "private".

---

``` countVote () ```

Compte le nombre de vote et renvoi l'id de la proposition gagnante. Le comptage n'est disponible que pour l'administrateur.

---

``` getWinner () ```

Renvoie la description du vote gagnant.

---

``` getStatus () ```

Renvoie le statut en cours du vote.

---

``` getVote (address) ```

Permet d'afficher le vote d'une adresse en particulier.

---

``` rateOfParticipation () ```

Permet d'afficher le pourcentage de participation au vote en pourcentage.