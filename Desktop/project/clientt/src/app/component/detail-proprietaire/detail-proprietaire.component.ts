import {Component, Input, OnInit} from '@angular/core';
import {User, UserService} from "../../services/user/user.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-detail-proprietaire',
  templateUrl: './detail-proprietaire.component.html',
  styleUrls: ['./detail-proprietaire.component.css']
})
export class DetailProprietaireComponent implements OnInit{
  userId: any; // Stockez l'ID de l'utilisateur ici
  user: User | null = null;
  detail:any

  constructor(private route: ActivatedRoute,
              private userService: UserService
  ) { }
  ngOnInit(): void {
    this.route.params.subscribe(async params => {
      const id = +params['id']; // Assurez-vous que l'ID est converti en nombre
      try {
        await this.getUserById(id);
        console.log("User is ", this.user);
      } catch (error) {
        console.error('Erreur lors de la récupération des détails de l\'utilisateur : ', error);
      }
    });

  }

  async getUserById(userId: number): Promise<User | null> {
    try {
      const response = await this.userService.getUserById(userId);
      this.user = response.data.user;
      console.log("User is ", this.user);
      return this.user;
    } catch (error) {
      console.error('Erreur lors de la récupération des détails de l\'utilisateur : ', error);
      return null; // Retourne null en cas d'erreur
    }
  }
}
