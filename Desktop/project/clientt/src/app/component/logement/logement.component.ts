import {Component,  OnInit, } from '@angular/core';
import {AppartementService} from "../../services/appartementService/appartement.service";
import {Router} from "@angular/router";


@Component({
  selector: 'app-logement',
  templateUrl: './logement.component.html',
  styleUrls: ['./logement.component.css']
})
export class LogementComponent implements OnInit{
  appartements: any[] = [];
  errorMessage: string = '';

  constructor(private router: Router, private appartementService: AppartementService
 ) { }



  ngOnInit(): void {
    this.fetchAppartements();
  }
  fetchAppartements(): void {
    this.appartementService.getAllAppartements()
      .then(response => {
        console.log('Raw response:', response);  // Ajout d'un log pour inspecter la réponse brute
        if (response.success) {
          this.appartements = response.data.data.appartements;
          console.log("Appartements:", this.appartements);  // Ajout d'un log pour vérifier le contenu des appartements
        } else {
          this.errorMessage = response.message;
          console.log("Error message:", this.errorMessage);  // Ajout d'un log pour vérifier le message d'erreur
        }
      })
      .catch(error => {
        console.error('Error:', error);
        this.errorMessage = 'Failed to load appartements. Please try again later.';
      });
  }

  goToAddAppartement(): void {
    this.router.navigate(['/addAppartement']);
  }


}
