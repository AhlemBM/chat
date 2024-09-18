import { Injectable } from '@angular/core';
import axios from "axios";
import {RegisterService} from "../authService/auth.service";

@Injectable({
  providedIn: 'root'
})
export class AppartementService {
  constructor(private authService: RegisterService) {
  }

  private backendUrl = 'http://localhost:9001/api/v1/appartement';

  async createAppartement(appartementData: { name: string; addresse: string; frais_menage: string; email: string }): Promise<any> {
    const token = localStorage.getItem('authToken');
    if (!token) {
      return {success: false, message: 'No authentication token found'};
    }

    try {
      const response = await axios.post(
        `${this.backendUrl}/create`,
        appartementData,
        {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        }
      );
      return {success: true, data: response.data};
    } catch (error: any) {
      return {success: false, message: error.response?.data?.message || 'Failed to create appartement'};
    }
  }

  async getAllAppartements(): Promise<any> {
    const token = localStorage.getItem('authToken');
    if (!token) {
      return { success: false, message: 'No authentication token found' };
    }

    try {
      const response = await axios.get(`${this.backendUrl}/getAll`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      return { success: true, data: response.data };
    } catch (error: any) {
      return { success: false, message: error.response?.data?.message || 'Failed to fetch appartements' };
    }
  }
}
